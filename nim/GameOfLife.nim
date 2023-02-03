import random
import std/strformat

const
  generations = 500
  height = 50
  width = 100

type Board = object
  cells: seq[bool]
  height: int
  width: int

proc getCell(board: Board, row: int, col: int): bool =
  if row >= 0 and col >= 0 and row < board.height and col < board.width:
    board.cells[(row * board.width) + col]
  else:
    false

proc nextGeneration(board: var Board) =
  var boardCopy = Board(height: height, width: width)
  for i in countup(0, (board.height*board.width)-1):
    boardCopy.cells.add(board.cells[i])

  for i in countup(0, height-1):
    for j in countup(0, width-1):
      var cell = getCell(boardCopy, i, j)
      var adjacent = 0

      for n in countup(-1, 1):
        for m in countup(-1, 1):
          if (n == 0 and m == 0):
            continue
          if getCell(boardCopy, i+n, j+m):
            adjacent += 1
      
      if cell:
        if adjacent < 2:
          cell = false
        if adjacent > 3:
          cell = false
      else:
        if adjacent == 3:
          cell = true

      board.cells[(i*board.width)+j] = cell

proc drawScreen(board: Board) =
  for i in countup(0, board.height-1):
    for j in countup(0, board.width-1):
      if board.cells[(i*board.width)+j]:
        write(stdout, "██")
      else:
        write(stdout, "  ")
    writeLine(stdout, "")

proc runGame(height: int, width: int, generations: int) =
  var board = Board(height: height, width: width)

  randomize()
  for i in countup(0, (height * width)-1):
    board.cells.add(sample([true, false]))

  for i in countup(0, generations-1):
    drawScreen(board)
    write(stdout, &"\x1b[{board.height}A")
    nextGeneration(board)

runGame(height, width, generations)