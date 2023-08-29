import random
from typing import List
cimport cython
from libc.stdlib cimport malloc, free
cdef extern from "stddef.h":
    ctypedef int size_t

cdef class Board:
    cdef size_t width
    cdef size_t height
    cdef unsigned char* cells
    cdef unsigned char* swap

    def __init__(self, size_t height, size_t width):
        cdef size_t size
        size = height * width
        self.cells = malloc(size)
        self.swap = self.cells
        self.height = height
        self.width = width

    def describe(self):
        print("This shrubbery is", self.width,
              "by", self.height, "cubits.")

    @cython.boundscheck(False)
    def draw(self):
        for i in range(self.height):
            for j in range(self.width):
                if self.cells[(i*self.width)+j]:
                    print("██", end="")
                else:
                    print("  ", end="")
            print("")

    @cython.boundscheck(False)
    def get_cell(self, row: int, col: int) -> bool:
        if 0 <= row < self.height and 0 <= col < self.width:
            return self.cells[(row*self.width)+col]
        else:
            return False
