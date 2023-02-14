module board;

import std.stdio;

class Board {
    int height;
    int width; 
    bool[] cells;

    this(int height, int width, bool[] cells) {
        this.height = height;
        this.width = width;
        this.cells = cells;
    }

    Board dup() const {
        return new Board(this.height, this.width, this.cells.dup());
    }

    bool getCell(int row, int col) {
        if (row >= 0 && col >= 0 && row < this.height && col < this.width) {
            return this.cells[(row * this.width) + col];
        } else {
            return false;
        }
    }

    void draw() {
        for (int i = 0; i < this.height; i++) {
            for (int j = 0; j < this.width; j++) {
                if (this.cells[(i * this.width) + j]) {
                    write("██");
                } else {
                    write("  ");
                }
            }
            writeln();
        }
    }
}