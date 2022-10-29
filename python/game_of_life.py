import os
import random
import time

from typing import List

import cursor
from screen import Screen

def run_game(screen: Screen):

    while True:
        cells: List[bool] = [bool(random.getrandbits(1)) for i in range(screen.size_1d)]
        screen.draw(cells)
        cursor.move_up(screen.height)
        time.sleep(5)


def main():
    columns, lines = os.get_terminal_size()
    print(f"Playing with a {columns-1}x{lines-1} screen")

    screen = Screen(lines-1, columns-1)
    run_game(screen)

if __name__ == "__main__":
    main()
    