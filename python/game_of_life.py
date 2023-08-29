from io import StringIO
from sys import stdout

from board import Board


def next_generation(board: Board):
    for i in range(board.height):
        for j in range(board.width):
            cell = board.get_cell(i, j)

            adjacent = (
                board.get_cell(i - 1, j - 1)
                + board.get_cell(i - 1, j)
                + board.get_cell(i - 1, j + 1)
                + board.get_cell(i, j - 1)
                + board.get_cell(i, j + 1)
                + board.get_cell(i + 1, j - 1)
                + board.get_cell(i + 1, j)
                + board.get_cell(i + 1, j + 1)
            )

            cell = adjacent == 3 or (cell and adjacent == 2)

            board.swap[(i * board.width) + j] = cell
    board.cells, board.swap = board.swap, board.cells


def run_game(height: int, width: int, generations: int):
    board = Board(height, width)

    clear = f"\033[{board.height}A"
    buf = StringIO(clear)
    clearlen = len(clear)

    for _ in range(generations):
        buf.seek(clearlen)
        buf = board.draw(buf)
        buf.truncate()
        stdout.write(buf.getvalue())
        stdout.flush()
        next_generation(board)


def main():
    generations = 500
    height = 50
    width = 100

    run_game(height, width, generations)


if __name__ == "__main__":
    main()
