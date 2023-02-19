import Data.Array
import System.Random

import Board
import Game

createCell :: Bool -> Cell
createCell True = Alive
createCell False = Dead

main = do
    let generations = 500
    let height = 50
    let width = 100

    let cells = array (0,(height*width)-1) [(i, createCell (fst (randomR (True, False) (mkStdGen i)))) | i <- [0..(height*width)-1]]
    let board = (Rect height width cells)
    
    run board generations
