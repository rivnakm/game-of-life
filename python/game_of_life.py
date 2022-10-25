import os
import random

from typing import List

import cursor
from screen import Screen

def run_game(screen: Screen):
    cells: List[bool] = [bool(random.getrandbits(1)) for i in range(screen.size_1d)]
    screen.draw(cells)
    cursor.move_up(5)
    print('uh')

def main():
    columns, lines = os.get_terminal_size()
    print(f"Playing with a {columns}x{lines} screen")

    screen = Screen(lines, columns)
    run_game(screen)

if __name__ == "__main__":
    main()
    