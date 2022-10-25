from typing import List, Tuple

class Screen:
    def __init__(self, height: int, width: int):
        self.height = height
        self.width = int(width / 2)

    def draw(self, cells: List[bool]):
        assert len(cells) == self.size_1d, "cells list size does not match screen size"
        for i in range(self.height):
            for j in range(self.width):
                match cells[(i*self.width)+j]:
                    case True:
                        print("██", end="")
                    case False:
                        print("  ", end="")
            print("")

    @property
    def size_1d(self) -> int:
        return self.height * self.width

    @property
    def size_2d(self) -> Tuple[int, int]:
        return self.height, self.width
