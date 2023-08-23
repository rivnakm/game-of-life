import random
from typing import List

class Board:
    def __init__(self, height: int, width: int, cells: List[bool] = []):
        self.cells: List[bool] = [bool(random.getrandbits(1)) for _ in range(height * width)] if len(cells) == 0 else cells
        self.height = height
        self.width = width

    def copy(self) -> "Board":
        return Board(self.height, self.width, self.cells.copy())

    def draw(self):
        for i in range(self.height):
            for j in range(self.width):
                if self.cells[(i*self.width)+j]:
                    print("██", end="")
                else:
                    print("  ", end="")
            print("")

    def get_cell(self, row: int, col: int) -> bool:
        if 0 <= row < self.height and 0 <= col < self.width:
            return self.cells[(row*self.width)+col]
        else:
            return False

    @property
    def size(self) -> int:
        return self.height * self.width
