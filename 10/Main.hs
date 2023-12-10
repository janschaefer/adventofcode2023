module Main where

import System.IO
import Data.List (elemIndex, find)
import Data.Maybe (catMaybes, fromMaybe)
import qualified Data.Set as Set

parseFile :: FilePath -> IO [[Char]]
parseFile path = do
    content <- readFile path
    return $ lines content

findPositions :: Char -> [[Char]] -> [(Int, Int)]
findPositions char arr = catMaybes [findPositionInLine char line row | (line, row) <- zip arr [0..]]

findPositionInLine :: Char -> [Char] -> Int -> Maybe (Int, Int)
findPositionInLine char line row = case elemIndex char line of
    Just col -> Just (row, col)
    Nothing  -> Nothing

getCharAtPosition :: [[Char]] -> (Int, Int) -> Char
getCharAtPosition arr (row, col) = (arr !! row) !! col

nextPositions :: Char -> (Int, Int) -> [(Int, Int)]
nextPositions char (row, col) = case char of
    '|' -> [(row + 1, col), (row - 1, col)]
    '-' -> [(row, col + 1), (row, col - 1)]
    'L' -> [(row - 1, col), (row, col + 1)]
    'J' -> [(row - 1, col), (row, col - 1)]
    '7' -> [(row, col - 1), (row + 1, col)]
    'F' -> [(row + 1, col), (row, col + 1)]
    '.' -> []
    _   -> []

nextPosition :: [[Char]] -> (Int, Int) -> Char -> (Int, Int) -> Maybe (Int, Int)
nextPosition arr prevPos curChar curPos = 
  find (/= prevPos) (nextPositions curChar curPos)

areConnected :: [[Char]] -> (Int, Int) -> (Int, Int) -> Bool
areConnected arr (row1, col1) (row2, col2) = 
  (row1, col1) `elem` nextPositions (getCharAtPosition arr (row2, col2)) (row2, col2)

traverseLoop ::  [[Char]] -> [(Int, Int)] -> (Int, Int) -> ((Int, Int), [(Int, Int)])
traverseLoop arr path curPos = 
    let curChar = getCharAtPosition arr curPos 
    in case curChar of
        'S' -> (curPos, path)
        _ -> case nextPosition arr (last path) curChar curPos of 
          Just nextPos -> traverseLoop arr (path ++ [curPos]) nextPos
          Nothing -> (curPos, path)

isInBounds :: (Int, Int) -> [[a]] -> Bool
isInBounds (row, col) arr = row >= 0 && row < length arr && col >= 0 && col < length (arr !! row)

findPath :: [[Char]] -> [(Int, Int)] 
findPath arr =
  let (row, col) = head (findPositions 'S' arr) in
  let possibleNextPositions = [(row, col-1), (row, col+1), (row-1, col), (row-1, col-1), (row-1, col+1), (row+1, col), (row+1, col+1), (row+1, col-1)] in
  let inBoundsPos = filter (`isInBounds` arr) possibleNextPositions in
  let connectedPositions = filter (areConnected arr (row, col)) inBoundsPos in
  let firstPipePos = head connectedPositions in
  let (targetPos, path) = traverseLoop arr [(row, col)] firstPipePos in
  path
   
closesLoop :: Char -> Char -> Bool
closesLoop startChar endChar = case startChar of
  '7' -> endChar == 'F'
  'J' -> endChar == 'L'
  _ -> False
  
countPathHits :: Set.Set(Int,Int) -> [[Char]] -> Int -> Maybe Char -> (Int, Int) -> Int
countPathHits pathPositions arr hits lastHit (row, col) = case col-1 of
  -2 -> hits
  x -> 
    if (row, col) `elem` pathPositions 
    then let curChar = arr !! row !! col in
      if (row, col+1) `elem` pathPositions && areConnected arr (row, col) (row, col+1 ) 
      then 
        if closesLoop (fromMaybe '.' lastHit) curChar
        then countPathHits pathPositions arr (hits - 1) Nothing (row, col-1)
        else countPathHits pathPositions arr hits lastHit (row, col-1)
      else countPathHits pathPositions arr (hits + 1) (Just curChar) (row, col-1)
    else countPathHits pathPositions arr hits Nothing (row, col-1)  

solve :: [[Char]] -> IO ()
solve arr = do
  let path = findPath arr
  print $ length path `div` 2

solve2 :: [[Char]] -> IO ()
solve2 arr = do
  let path = findPath arr
  let m = length arr 
  let n = length (head arr)  
  let pathPositions = Set.fromList path
  let allPossiblePositions = [(i, j) | i <- [0..m-1], j <- [0..n-1], not (Set.member (i, j) pathPositions)]
  let oddPositions = filter (\x -> odd (countPathHits pathPositions arr 0 Nothing x) ) allPossiblePositions
  print $ length $ oddPositions

main :: IO ()
main = do
  arr <- parseFile "input"
  solve arr
  solve2 arr
