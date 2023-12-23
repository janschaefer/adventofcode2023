import Foundation

func printArray(array: [[Character]]) {
  for row in array {
      for c in row {
          print(c, terminator: "")
      }
      print()
  }
}

func parse(file: String) -> [[Character]] {
   let content = try! String(contentsOfFile: file, encoding: .utf8)
   let lines = content.split(separator: "\n")
   let data: [[Character]] = lines.map { line in Array(line) }
   return data
}

func findPath( maze: [[Character]], path: [(Int, Int)], pos:(Int,Int), visited: Set<Int>) -> [(Int, Int)] {
  let (row, col) = pos

  if row < 0 || col < 0 || row == maze.count || col == maze[0].count {
    return []
  }

  let c = maze[row][col]
  if c == "#" {
    return []
  }

  let hash = row * maze.count + col
  if visited.contains(hash) {
    return []
  }

  var newVisited = visited
  newVisited.insert(hash)

  var newPath = path
  newPath.append(pos)

  if row == maze.count - 1 && col == maze[0].count - 2 {
    return newPath
  }

  if c == "." {
    let nextPositions = [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1)]
    let nextPaths = nextPositions.map { 
        findPath(maze: maze, path: newPath, pos: $0, visited: newVisited) 
    }
    let longestPath = nextPaths.max(by: { $0.count < $1.count })
    return longestPath!
  }

  if c == ">" {
    return findPath(maze: maze, path: newPath, pos: (row, col + 1), visited: newVisited)
  } else if (c == "v") {
    return findPath(maze: maze, path: newPath, pos: (row + 1, col), visited: newVisited)
  } else if (c == "^") {
    return findPath(maze: maze, path: newPath, pos: (row - 1, col), visited: newVisited)
  } else if (c == "<") {
    return findPath(maze: maze, path: newPath, pos: (row, col - 1), visited: newVisited)
  }

  return []
}

struct Path {
    var start: (Int, Int)
    var end: (Int, Int)
    var length: Int
}

func possible_neightbours( maze: [[Character]], pos: (Int, Int) ) -> [(Int, Int)] {
    let (row, col) = pos
    return [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1)].filter {
        let (r, c) = $0
        return !(r < 0 || c < 0 || r == maze.count || c == maze[0].count || maze[r][c] == "#")
    }

}

func count_neighbours( maze: [[Character]], pos: (Int, Int)) -> Int {
    return possible_neightbours(maze: maze, pos: pos).count
}

func findNodes( maze: [[Character]]) -> [Int: (Int, Int)] {
    var nodes: [Int: (Int, Int)] = [:]

    for row in 0..<maze.count {
        for col in 0..<maze[0].count {
            if maze[row][col] != "#" {
                let count = count_neighbours( maze: maze, pos: (row,col) )
                if count > 2 {
                  let hash = row * maze.count + col
                  nodes[hash] = (row,col)
                }
            }
        }
    }

    return nodes;
}


func hash_pos(_ maze: [[Character]], _ pos: (Int, Int)) -> Int {
  let (row, col) = pos
  return row * maze.count + col
}

func findPathToOtherNode( maze: [[Character]], nodes: [Int: (Int, Int)], path: [(Int, Int)], pos: (Int, Int)) -> [(Int, Int)] {
  let (row, col) = pos

  var newPath = path;
  newPath.append(pos)

  let hash = row * maze.count + col
  if nodes[hash] != nil {
     return newPath
  }

  let nextPositions = possible_neightbours( maze: maze, pos: pos).filter { $0 != path[path.count - 1] }

  if nextPositions.count == 1 {
      return findPathToOtherNode(maze: maze, nodes: nodes, path: newPath, pos: nextPositions[0]) 
  }

  return []
}


func find_longest_path( visited: Set<Int>, targetNode: Int, paths: [Int: [(Int, Int, Int)]], pathLength: Int, currentNode: Int) -> Int {

    if currentNode == targetNode {
        return pathLength
    }

    var newVisited = visited
    newVisited.insert(currentNode)

    let possible_paths = paths[currentNode]!.filter { 
        let (_, to, _) = $0
        return !visited.contains(to)
    }

    let finished_paths: [Int] = possible_paths.map { 
        let (_, to, len) = $0
        return find_longest_path( visited: newVisited, targetNode: targetNode, paths: paths, pathLength: pathLength + len, currentNode: to )
    }

    if let max = finished_paths.max() {
        return max
    } else {
        return 0
    }
}


func solve(maze: [[Character]]) {
  let foundPath = findPath(maze: maze, path: [], pos: (0,1), visited: Set<Int>())
  print(foundPath.count - 1)
}

func solve2(maze: [[Character]]) {
    var nodes = findNodes(maze: maze)

    let startPos = (0,1)
    let endPos = (maze.count - 1, maze[0].count - 2)

    let endNode = hash_pos(maze, endPos)
    let startNode = hash_pos(maze, startPos)

    nodes[startNode] = startPos
    nodes[endNode] = endPos

    var paths: [(Int, Int, Int)] = []

    for nodeHash in nodes.keys {
        let node = nodes[nodeHash]!
        let startPositions = possible_neightbours( maze: maze, pos: node)
        for startPos in startPositions {
            let path = findPathToOtherNode( maze: maze, nodes: nodes, path: [node], pos: startPos)
            let hash_end_node = hash_pos( maze, path[path.count - 1])
            paths.append( (nodeHash, hash_end_node, path.count - 1) )
        }
    }

    var path_hash: [Int: [(Int, Int, Int)]] = [:]
    for nodeHash in nodes.keys {
        let possible_paths = paths.filter { 
           let (from, _, _) = $0
           return from == nodeHash
        }
        path_hash[nodeHash] = possible_paths
    }

    print(find_longest_path(visited: Set<Int>(), targetNode: endNode, paths: path_hash, pathLength: 0, currentNode: startNode))
}

let array = parse(file: "input")
solve(maze: array)
solve2(maze: array)
