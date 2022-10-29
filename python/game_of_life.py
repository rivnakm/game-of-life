import os
import random
import time

from typing import List

import cursor
from screen import Screen

def next_generation(cells, height, width):
    pass

def run_game(screen: Screen, iterations: int = -1):
    cells: List[bool] = [bool(random.getrandbits(1)) for _ in range(screen.size_1d)]

    if iterations == -1:
        while True:
            screen.draw(cells)
            cursor.move_up(screen.height)
            time.sleep(1)
    else:
        for _ in range(iterations):
            screen.draw(cells)
            cursor.move_up(screen.height)
            time.sleep(1)

def main():
    columns, lines = os.get_terminal_size()
    print(f"Playing with a {columns}x{lines-1} screen")

    screen = Screen(lines-1, columns)
    run_game(screen)

if __name__ == "__main__":
    main()
    