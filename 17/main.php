<?php

class Node {
  public $totalHeatLoss;
  public $pos;
  public $dir;
  public $consecutiveMoves;
  public $prevNode;
  public $visited;

  public function __construct($totalHeatLoss, $pos, $dir, $consecutiveMoves) {
    $this->totalHeatLoss = $totalHeatLoss;
    $this->pos = $pos;
    $this->dir = $dir;
    $this->prevNode = null;
    $this->consecutiveMoves = $consecutiveMoves;
    $this->visited = False;
  }
}

function getNodeWithMinimalHeatLoss(& $nodes) {
  $minHeatLoss = PHP_INT_MAX;
  $minNode = null;
  $key = null;
  foreach ($nodes as $k => $node) {
    if ($node->totalHeatLoss < $minHeatLoss) {
      $minHeatLoss = $node->totalHeatLoss;
      $minNode = $node;
      $key = $k;
    }
  }

  unset($nodes[$key]);

  return $minNode;
}

function createNode($array, & $nodeMap, $pos, $dir, $consecutiveMoves) {
  if ($pos[0] < 0 || $pos[1] < 0 || $pos[0] >= count($array) || $pos[1] >= count($array[0])) {
    return null;
  }

  $key = $pos[0] . ',' . $pos[1] . $dir . $consecutiveMoves;

  $n = null;

  if (!array_key_exists($key, $nodeMap)) {
    $n = new Node(PHP_INT_MAX, $pos, $dir, $consecutiveMoves);
    $nodeMap[$key] = $n;
  } else {
    $n = $nodeMap[$key];
    if ($n->visited) {
      return null;
    }
  }

  return $n;
}

function turnLeft($dir) {
  if ($dir == '>') return '^';
  if ($dir == '^') return '<';
  if ($dir == '<') return 'v';
  if ($dir == 'v') return '>';
}

function turnRight($dir) {
  if ($dir == '>') return 'v';
  if ($dir == 'v') return '<';
  if ($dir == '<') return '^';
  if ($dir == '^') return '>';
}

function getNextPos($pos, $dir) {
  if ($dir == '>') return [$pos[0], $pos[1] + 1];
  if ($dir == '<') return [$pos[0], $pos[1] - 1];
  if ($dir == 'v') return [$pos[0] + 1, $pos[1]];
  if ($dir == '^') return [$pos[0] - 1, $pos[1]];
}

function nextNode($array, $pos, $oldDir, $consecMoves, $dir, & $nodeMap) {
  return createNode($array, $nodeMap, getNextPos($pos, $dir), $dir, $consecMoves);
}

function getNeighbours($array, $node, & $nodeMap, $min, $max) {
  $pos = $node->pos;
  $dir = $node->dir;
  $consecMoves = $node->consecutiveMoves;

  $neighbors = [];

  if ($consecMoves + 1 < $max) {
    $n = nextNode($array, $pos, $dir, $consecMoves + 1, $dir, $nodeMap);
    if ($n != null) $neighbors[] = $n;
  }

  if ($consecMoves >= $min) {
    $n = nextNode($array, $pos, $dir, 0, turnLeft($dir), $nodeMap, $max);
    if ($n != null) $neighbors[] = $n;
    
    $n = nextNode($array, $pos, $dir, 0, turnRight($dir), $nodeMap, $max);
    if ($n != null) $neighbors[] = $n;
  }

  return $neighbors;
}

function dijkstra($array, $unvisitedNodes, $min, $max) {

  $nodeMap = [];
  while (true) {
    $currentNode = getNodeWithMinimalHeatLoss($unvisitedNodes);

    $currentNode->visited = true;

    if ($currentNode->pos == [count($array) - 1, count($array) - 1]) {
      return $currentNode;
    }

    $neighbourNodes = getNeighbours($array, $currentNode, $nodeMap, $min, $max);

    foreach ($neighbourNodes as $node) {
      $nrow = $node->pos[0];
      $ncol = $node->pos[1];
      $heatLoss = $currentNode->totalHeatLoss + $array[$node->pos[0]][$node->pos[1]];
      if ($heatLoss < $node->totalHeatLoss) {
        $node->prevNode = $currentNode;
        $node->totalHeatLoss = $heatLoss;
        $unvisitedNodes[] = $node;
      }
    }
  }
}

function parse($filename) {
  $lines = file($filename);

  $charArray2D = [];

  foreach ($lines as $line) {
      $charArray2D[] = str_split(trim($line));
  }
  return $charArray2D;
}


function getPath($path, $currentNode) {
  if ($currentNode == null) {
    return $path;
  }
  $path[] = $currentNode;
  return getPath($path, $currentNode->prevNode);
}

function print_array($array, $space) {
  foreach ($array as $row) {
      foreach ($row as $element) {
          $value = $element == PHP_INT_MAX ? "" : $element;
          echo $element . $space;
      }
      echo "\n"; 
  }
}

function print_path($array, $path) {
  $newArray = [];
  for ($row = 0; $row < count($array); $row++) {
    $newRow = [];    
    for ($col = 0; $col < count($array[0]); $col++) {
      $newRow[] = $array[$row][$col];
    }
    $newArray[] = $newRow;
  }

  foreach ($path as $p) {
    $newArray[$p->pos[0]][$p->pos[1]] = $p->dir; //$p->heatLoss;
  }

  print_array($newArray, "");
}

function solve($filename) {
  $array = parse($filename);

  $finalNode = dijkstra($array, [new Node(0, [0,0], '>', 0), new Node(0, [0,0], 'v', 0)], 0, 3);
  $path = array_reverse(getPath([], $finalNode));

 //print_r("\n");
  //print_path($array, $path);

  print_r( $finalNode->totalHeatLoss . "\n");
}

function solve2($filename) {
    $array = parse($filename);

    $finalNode = dijkstra($array, [new Node(0, [0,0], '>', 0), new Node(0, [0,0], 'v', 0)], 3, 10);
    $path = array_reverse(getPath([], $finalNode));

   // print_r("\n");
   //print_path($array, $path);

    print_r($finalNode->totalHeatLoss . "\n");
}

solve("input");
solve2("input");

?>
