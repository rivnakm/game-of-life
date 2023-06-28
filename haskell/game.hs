module Game
( run
) where

import Data.Array
import System.Random

import Board

isAlive :: Int -> Cell -> Cell
isAlive 2 cell = cell
isAlive 3 _ = Alive
isAlive _ _ = Dead

isInBounds :: Int -> Int -> Int -> Int -> Bool
isInBounds row col height width =
    (row >= 0) && (row < height) && (col >= 0) && (col < width)

adjacentCells :: Int -> Int -> [(Int, Int)]
adjacentCells r c = [
    (r-1, c-1), (r-1, c), (r-1, c+1),
    (r, c-1), (r, c+1),
    (r+1, c-1), (r+1, c), (r+1, c+1)
    ]

readAdjacent :: Board -> [(Int, Int)] -> Int
readAdjacent (Rect height width cells) [] = 0
readAdjacent (Rect height width cells) (x:xs) =
    case cell of
        Alive -> 1 + readAdjacent (Rect height width cells) xs
        Dead -> readAdjacent (Rect height width cells) xs
    where
        (r, c) = x
        cell = if (isInBounds r c height width) then cells ! (r * width + c) else Dead

generateCell :: Board -> Int -> Int -> Cell
generateCell (Rect height width cells) row col =
    isAlive numAdjacent current
    where
        current = cells ! (row*width+col)
        numAdjacent = readAdjacent (Rect height width cells) (adjacentCells row col)

nextGeneration :: Board -> Board
nextGeneration (Rect height width cells) =
    (Rect height width next)
    where
        next = array (0,(height*width)-1) [(i*width+j, generateCell (Rect height width cells) i j) | i <- [0..height-1], j <- [0..width-1]]

drawCell :: Board -> Int -> Int -> IO ()
drawCell (Rect height width cells) row col = do
    putStr (case cell of
        Alive -> "██"
        Dead -> "  ")

    if (col + 1 < width) then do
        drawCell (Rect height width cells) row (col + 1)
    else do
        pure ()
    where
        cell = cells ! (row * width + col)

drawRow :: Board -> Int -> IO ()
drawRow (Rect height width cells) row = do
    drawCell (Rect height width cells) row 0
    putStrLn ""

    if (row + 1 < height) then do
        drawRow (Rect height width cells) (row+1)
    else do
        pure ()

drawScreen :: Board -> IO ()
drawScreen (Rect height width cells) = do
    drawRow (Rect height width cells) 0

run :: Board -> Int -> IO ()
run _ 0 = do pure ()
run (Rect height width cells) generations = do
    drawScreen (Rect height width cells)
    putStr ("\x1b[" ++ show height ++ "A")
    run newBoard (generations-1)
    where
        newBoard = nextGeneration (Rect height width cells)
    
