import random
import std/strformat

import os

const
  generations = 100
  height = 50
  width = 100

proc getCell(cells: seq[bool], row: int, col: int, height: int, width: int): bool =
  if row >= 0 and col >= 0 and row < height and col < width:
    cells[(row * width) + col]
  else:
    false

proc nextGeneration(cells: var seq[bool], height: int, width: int) =
  var cellsCopy: seq[bool]
  for i in countup(0, (height*width)-1):
    cellsCopy.add(cells[i])

  for i in countup(0, height-1):
    for j in countup(0, width-1):
      var cell = getCell(cellsCopy, i, j, height, width)
      var adjacent = 0

      for n in countup(-1, 1):
        for m in countup(-1, 1):
          if (n == -1 and i == 0) or (m == -1 and j == 0) or (n == 0 and m == 0):
            continue
          if getCell(cellsCopy, i+n, j+m, height, width):
            adjacent += 1
      
      if cell:
        if adjacent < 2:
          cell = false
        if adjacent > 3:
          cell = false
      else:
        if adjacent == 3:
          cell = true

      cells[(i*width)+j] = cell

proc drawScreen(cells: seq[bool], height: int, width: int) =
  for i in countup(0, height-1):
    for j in countup(0, width-1):
      if cells[(i*width)+j]:
        write(stdout, "██")
      else:
        write(stdout, "  ")
    writeLine(stdout, "")

proc runGame(height: int, width: int, generations: int) =
  var cells: seq[bool]

  randomize()
  for i in countup(0, (height * width)-1):
    cells.add(sample([true, false]))

  for i in countup(0, generations-1):
    drawScreen(cells, height, width)
    write(stdout, &"\x1b[{height}A")
    nextGeneration(cells, height, width)

runGame(height, width, generations)