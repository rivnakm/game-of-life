module Board
( Board(..)
, Cell(..)
) where

import Data.Array

data Cell = Alive | Dead deriving (Eq, Show)

data Board = Rect Int Int (Array Int Cell)