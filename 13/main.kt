import java.io.File

fun parseFile(filePath: String): List<List<String>> {
  val content = File(filePath).readText()
  return content.split("\n\n").map { it.split("\n") }
}

fun colsEqual(col1: Int, col2: Int, pattern: Array<Array<Char>>): Boolean {
  for (rowIndex in 0 until pattern.size) {
    if (pattern[rowIndex][col1] != pattern[rowIndex][col2]) {
      return false;
    }
  }
  return true;
}

fun isVerticalMirror(colIndex: Int, pattern: Array<Array<Char>>): Boolean {
  var max = Math.min(colIndex, pattern[0].size - colIndex)
  for (i in 0 until max) {
    var col1 = colIndex - i - 1;
    var col2 = colIndex + i;
    if (! colsEqual(col1, col2, pattern)) {
      return false;
    }
  }
  return true;
}

// returns the number of cols left to the mirror
fun findVerticalMirror(pattern: Array<Array<Char>>): Int {
  for (colIndex in 1 until pattern[0].size) {
    if (isVerticalMirror(colIndex, pattern)) {
      return colIndex;
    }
  }
  return 0;
}

fun isHorizontalMirror(rowIndex: Int, pattern: Array<Array<Char>>): Boolean {
  var max = Math.min(rowIndex, pattern.size - rowIndex)
  for (i in 0 until max) {
    var row1 = pattern[rowIndex - i - 1]
    var row2 = pattern[rowIndex + i]
    if (! row1.contentEquals(row2)) {
      return false;
    }
  }
  return true;
}

// returns the number of rows above the mirror
fun findHorizontalMirror(pattern: Array<Array<Char>>): Int {
  for (rowIndex in 1 until pattern.size) {
    if (isHorizontalMirror(rowIndex, pattern)) {
      return rowIndex;
    }
  }
  return 0;
}

fun solvePattern(patternInput: List<String>): Int {
  var pattern: Array<Array<Char>> = patternInput.map { 
    it.toCharArray().toTypedArray() }.toTypedArray()

  var horizontalMirror = findHorizontalMirror(pattern);
  var verticalMirror = findVerticalMirror(pattern);

  return verticalMirror + (horizontalMirror * 100);
}

fun solve(patterns: List<List<String>>) {
  println(patterns.map({ solvePattern(it) }).sum());
}


// compares the rows and accepts one difference
// return 0 if equal, 1 if equal with one nudge, 2 if more than two nudges are required
fun colsEqualWithNudge(col1: Int, col2: Int, pattern: Array<Array<Char>>): Int {
  var nudges = 0;
  for (rowIndex in 0 until pattern.size) {
    if (pattern[rowIndex][col1] != pattern[rowIndex][col2]) {
      nudges++;
    }

    if (nudges > 1) {
      return 2;
    }
  }
  return nudges;
}

// compares the rows and accepts one difference
// return 0 if equal, 1 if equal with one nudge, 2 if more than two nudges are required
fun rowsEqualWithNudge(row1: Int, row2: Int, pattern: Array<Array<Char>>): Int {
  var nudges = 0;
  for (colIndex in 0 until pattern[0].size) {
    if (pattern[row1][colIndex] != pattern[row2][colIndex]) {
      nudges++;
    }

    if (nudges > 1) {
      return 2;
    }
  }
  return nudges;
}

fun isVerticalMirrorWithNudge(colIndex: Int, pattern: Array<Array<Char>>): Boolean {
  var max = Math.min(colIndex, pattern[0].size - colIndex);
  var nudges = 0;
  for (i in 0 until max) {
    var col1 = colIndex - i - 1;
    var col2 = colIndex + i;
    nudges += colsEqualWithNudge(col1, col2, pattern);

    if (nudges > 1) {
      return false;
    }
  }
  return nudges == 1;
}

// returns the number of cols left to the mirror
fun findVerticalMirrorWithNudge(pattern: Array<Array<Char>>): Int {
  for (colIndex in 1 until pattern[0].size) {
    if (isVerticalMirrorWithNudge(colIndex, pattern)) {
      return colIndex;
    }
  }
  return 0;
}

fun isHorizontalMirrorWithNudge(rowIndex: Int, pattern: Array<Array<Char>>): Boolean {
  var max = Math.min(rowIndex, pattern.size - rowIndex)
  var nudges = 0;

  for (i in 0 until max) {
    var row1 = rowIndex - i - 1;
    var row2 = rowIndex + i;
    nudges += rowsEqualWithNudge(row1, row2, pattern);
  
    if (nudges > 1) {
      return false;
    }
  }
  return nudges == 1;
}

// returns the number of rows above the mirror
fun findHorizontalMirrorWithNudge(pattern: Array<Array<Char>>): Int {
  for (rowIndex in 1 until pattern.size) {
    if (isHorizontalMirrorWithNudge(rowIndex, pattern)) {
      return rowIndex;
    }
  }
  return 0;
}

fun solvePattern2(patternInput: List<String>): Int {
  var pattern: Array<Array<Char>> = patternInput.map { 
    it.toCharArray().toTypedArray() }.toTypedArray()

  var horizontalMirror = findHorizontalMirrorWithNudge(pattern);
  var verticalMirror = findVerticalMirrorWithNudge(pattern);

  return verticalMirror + (horizontalMirror * 100);
}

fun solve2(patterns: List<List<String>>) {
  println(patterns.map({ solvePattern2(it) }).sum());
}

fun main(args: Array<String>) {
  var patterns = parseFile("input")
  solve(patterns);
  solve2(patterns);
}
