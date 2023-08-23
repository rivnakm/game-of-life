import random
from typing import List

from board import Board

def next_generation(board: Board):
    board_copy = board.copy()

    cdef int i
    cdef int j
    cdef int adjacent
    for i in range(board.height):
        for j in range(board.width):
            cell = board_copy.get_cell(i, j)

            adjacent = 0

            for n in range(-1,2):
                for m in range(-1,2):
                    if (n == 0 and m == 0):
                        continue
                    if board_copy.get_cell(i+n, j+m):
                        adjacent += 1

            if cell:
                if adjacent < 2:
                    cell = False
                if adjacent > 3:
                    cell = False
            else:
                if adjacent == 3:
                    cell = True

            board.cells[(i*board.width)+j] = cell

def run_game(height: int, width: int, generations: int):
    board = Board(height, width)

    for _ in range(generations):
        board.draw()
        print(f"\033[{board.height}A", end="")
        next_generation(board)

