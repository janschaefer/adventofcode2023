function parseInput(filePath)
  local file = io.open(filePath, "r")  -- Open file for reading
  if not file then return nil end      -- Return nil if file can't be opened

  local array2D = {}
  for line in file:lines() do
      local row = {}
      for char in line:gmatch(".") do   -- Iterate over each character in the line
          table.insert(row, char)       -- Insert character into the row
      end
      table.insert(array2D, row)        -- Insert row into the 2D array
  end

  file:close()                          -- Close the file
  return array2D
end

function copyRoundedRockPositions(roundedRocks)
  local newArray = {}
  for i, value in ipairs(roundedRocks) do
      newArray[i] = {row = value.row, column = value.column }
  end
  return newArray
end

function positionsAreEqual(roundedRocks1, roundedRocks2)
  for i = 1, #roundedRocks1 do
      if roundedRocks1[i].row ~= roundedRocks2[i].row then
          return false
      end
      if roundedRocks1[i].column ~= roundedRocks2[i].column then
          return false
      end
  end
  return true
end

function findRockPositions(history, roundedRocks) 
  for i = 1, #history do
    if positionsAreEqual(history[i], roundedRocks) then
      return i
    end
  end
  return -1
end

function findRoundedRocks(array2D)
  local positions = {}
  for rowIndex, row in ipairs(array2D) do
      for columnIndex, char in ipairs(row) do
          if char == 'O' then
              table.insert(positions, {row = rowIndex, column = columnIndex})
          end
      end
  end
  return positions
end

local function sortByRowDesc(a, b) 
  if (a.row == b.row) then
    return a.column > b.column
  end
  return a.row > b.row;
end

local function sortByRowAsc(a, b) 
  if (a.row == b.row) then
    return a.column < b.column
  end
  return a.row < b.row;
end

local function sortByColDesc(a, b) 
  if (a.column == b.column) then
    return a.row > b.row
  end
  return a.column > b.column;
end

local function sortByColAsc(a, b) 
  if (a.column == b.column) then
    return a.row < b.row
  end
  return a.column < b.column;
end


function tiltNorth(array2D, roundedRocks)
  table.sort(roundedRocks, sortByRowAsc)
  for _, pos in ipairs(roundedRocks) do
      while pos.row > 1 and array2D[pos.row - 1][pos.column] == '.' do
        array2D[pos.row][pos.column] = '.'
        pos.row = pos.row - 1
        array2D[pos.row][pos.column] = 'O'
      end
  end
end

function tiltSouth(array2D, roundedRocks)
  table.sort(roundedRocks, sortByRowDesc)
  for _, pos in ipairs(roundedRocks) do
      while pos.row < #array2D and array2D[pos.row + 1][pos.column] == '.' do
        array2D[pos.row][pos.column] = '.'
        pos.row = pos.row + 1
        array2D[pos.row][pos.column] = 'O'
      end
  end
end

function tiltEast(array2D, roundedRocks)
  table.sort(roundedRocks, sortByColDesc)
  for _, pos in ipairs(roundedRocks) do
      while pos.column < #array2D and array2D[pos.row][pos.column + 1] == '.' do
        array2D[pos.row][pos.column] = '.'
        pos.column = pos.column + 1
        array2D[pos.row][pos.column] = 'O'
      end
  end
end

function tiltWest(array2D, roundedRocks)
  table.sort(roundedRocks, sortByColAsc)
  for _, pos in ipairs(roundedRocks) do
      while pos.column > 1 and array2D[pos.row][pos.column - 1] == '.' do
        array2D[pos.row][pos.column] = '.'
        pos.column = pos.column - 1
        array2D[pos.row][pos.column] = 'O'
      end
  end
end

function cycle(charArray2D, roundedRocks)
  tiltNorth(charArray2D, roundedRocks)
  tiltWest(charArray2D, roundedRocks)
  tiltSouth(charArray2D, roundedRocks)
  tiltEast(charArray2D, roundedRocks)
end


function calculateWeight(array2D, roundedRocks)
  local totalWeight = 0
  for _, pos in ipairs(roundedRocks) do
    local weight = (#array2D - pos.row) + 1
    totalWeight = totalWeight + weight
  end
  return totalWeight
end

function printArray(array2D)
  for i, row in ipairs(array2D) do
      for j, char in ipairs(row) do
          io.write(char)
      end
      io.write("\n")
  end
  io.write("\n")
  
end

function solve(pathToFile)
  local charArray2D = parseInput(pathToFile)
  local roundedRocks = findRoundedRocks(charArray2D)
  tiltNorth(charArray2D, roundedRocks)
  io.write(calculateWeight(charArray2D, roundedRocks))
  io.write("\n")
end

function solve2(pathToFile)
  local charArray2D = parseInput(pathToFile)
  local roundedRocks = findRoundedRocks(charArray2D)
  
  local historyOfPos = { }
  
  local countUntilRepeats;
  local cycleLength
  for i = 1, 1000000000 do
    cycle(charArray2D, roundedRocks)
  
    local existingPos = findRockPositions(historyOfPos, roundedRocks)
    if existingPos > -1 then
      countUntilRepeats = existingPos
      cycleLength = i - countUntilRepeats
      break
    end
  
    table.insert(historyOfPos, copyRoundedRockPositions(roundedRocks))
  end
  
  local remainingCycles = (1000000000 - countUntilRepeats) % cycleLength
  
  for i = 1, remainingCycles do
    cycle(charArray2D, roundedRocks)
  end
  
  
  io.write(calculateWeight(charArray2D, roundedRocks))
  io.write("\n")
end

local pathToFile = "input"
solve(pathToFile)
solve2(pathToFile)
