import random
from typing import List
from io import StringIO

# import copy


class Board:
    def __init__(self, height: int, width: int, cells: List[bool] = [], swap: List[bool] = []):
        self.cells: List[bool] = [bool(random.getrandbits(1)) for _ in range(height * width)] if len(cells) == 0 else cells
        self.swap: List[bool] = [False] * (height * width) if len(swap) == 0 else swap
        self.height = height
        self.width = width

    def draw(self, buf: StringIO) -> StringIO:
        for i in range(self.height):
            for j in range(self.width):
                if self.cells[(i * self.width) + j]:
                    buf.write("██")
                else:
                    buf.write("  ")
            buf.write("\n")
        return buf

    def get_cell(self, row: int, col: int) -> int:
        if 0 <= row < self.height and 0 <= col < self.width:
            return self.cells[(row * self.width) + col]
        else:
            return False

    @property
    def size(self) -> int:
        return self.height * self.width
