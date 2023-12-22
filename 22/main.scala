import scala.io.Source

case class Point3D(var x: Int, var y: Int, var z: Int)

case class Block(id: String, start: Point3D, end: Point3D)

object Main {
  def parsePoint(line: String): Point3D = {
    val coords  = line.split(",")
    Point3D(coords(0).toInt, coords(1).toInt, coords(2).toInt)
  }
  
  def parseBlock(id: String, line: String): Block = {
    val split = line.split("~")
    Block(id, parsePoint(split(0)), parsePoint(split(1)))
  }
  
  def parseFile(filePath: String): List[Block] = {
    try {
      Source.fromFile(filePath).getLines().zipWithIndex.map {
        case (line, index) => parseBlock(f"$index%04d", line) 
      }.toList
    } catch {
      case e: Exception => {
        println("Error reading file: " + e.getMessage)
        List()
      }
    }
  }

  def fallOn(b: Block, onto: Block) {
    val fallHeight = (b.start.z - onto.end.z) - 1
    b.start.z -= fallHeight
    b.end.z -= fallHeight
  }

  def intersects_in_z_axis(b1: Block, b2: Block): Boolean = {
    !(b1.start.x > b2.end.x || 
      b1.end.x < b2.start.x ||
      b1.start.y > b2.end.y ||
      b1.end.y < b2.start.y)
  }

  def onTop(block: Block, onTopOf: Block): Boolean = {
    onTopOf.end.z + 1 == block.start.z
  }

  def simulateFalling(blocks: List[Block]) {
    var blocksInAir = blocks.sortWith( (a, b) => a.start.z < b.start.z );
    
    // we add a single ground block to simplifiy the calculations
    val groundBlock = Block("-", Point3D(0, 0, 0), Point3D(9,9, 0))
    var fallenBlocks = List(groundBlock)
    
    while (blocksInAir.size > 0) {
      blocksInAir match {
        case head :: tail => 
          val highestBelowBlock = fallenBlocks
            .filter(b => intersects_in_z_axis(head, b))
            .reduce( (a,b) => if (a.end.z > b.end.z) a else b )
          fallOn(head, highestBelowBlock)
          blocksInAir = tail
          fallenBlocks = fallenBlocks :+ head
      }
    }
  }

  def supportedBy(block: Block, supportedBy: Block): Boolean = {
    intersects_in_z_axis(block, supportedBy) && onTop(block, supportedBy)
  }

  def supportedByBlocks(block: Block, blocks: List[Block]): List[Block] = {
    blocks.filter(b => supportedBy(block, b))
  }

  def supportsBlocks(block: Block, blocks: List[Block]): List[Block] = {
    blocks.filter(b => supportedBy(b, block))
  }

  
  def canDisintegrate(block: Block, blocks: List[Block]): Boolean = {
    blocks
      .filter(b => supportedBy(b, block)
              && supportedByBlocks(b, blocks).size == 1)
      .size == 0
  }

  def print_xz_axis(blocks: List[Block]) {
    val max_x = blocks.map { _.end.x }.reduce( (a,b) => if (a > b) a else b );
    val max_z = blocks.map { _.end.z }.reduce( (a,b) => if (a > b) a else b );

    val array = Array.fill(max_z + 1, max_x + 1)("|....|")
    
    blocks.foreach(b => {
      for (x <- b.start.x to b.end.x) {
        for (z <- b.start.z to b.end.z) {
          array(z)(x) = "|" + b.id + "|"
        }
      }
    })

    for (row <- array.reverse) {
      for (char <- row) {
        print(char)
      }
      println()
    }
  }

  def print_yz_axis(blocks: List[Block]) {
    val max_y = blocks.map { _.end.y }.reduce( (a,b) => if (a > b) a else b );
    val max_z = blocks.map { _.end.z }.reduce( (a,b) => if (a > b) a else b );

    val array = Array.fill(max_z + 1, max_y + 1)("|....|")

    blocks.foreach(b => {
      for (y <- b.start.y to b.end.y) {
        for (z <- b.start.z to b.end.z) {
          array(z)(y) = "|" + b.id + "|"
        }
      }
    })

    for (row <- array.reverse) {
      for (char <- row) {
        print(char)
      }
      println()
    }
  }

  def solve(blocks: List[Block]) {
    val groundBlock = Block("----", Point3D(0, 0, 0), Point3D(9, 9, 0))

    simulateFalling(blocks)

    val canDisintegrateBlocks = blocks.filter(b => canDisintegrate(b, blocks)).map( b => b.id)
    val count = canDisintegrateBlocks.size

    println(count)
  }

  def solve2(blocks: List[Block]) {
    simulateFalling(blocks)

    var sum = 0;
    blocks.foreach(b => {
      // need to deep copy
      val otherBlocks = blocks.filter(c => c != b)
      val otherBlocksCopy = otherBlocks.map( b => Block(b.id, Point3D(b.start.x, b.start.y, b.start.z), Point3D(b.end.x, b.end.y, b.end.z)))
      simulateFalling(otherBlocksCopy)
      val fallenBlocks = otherBlocksCopy.zip(otherBlocks).count { case (b1, b2) => b1.start.z != b2.start.z }
      sum += fallenBlocks
    })
    println(sum)

  }
  
  def main(args: Array[String]): Unit = {
    val blocks = parseFile("input")
    solve(blocks)
    solve2(blocks)
  }
}
