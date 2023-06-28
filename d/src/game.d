module game;

import std.container;
import std.random;
import std.stdio;

import board;

static void nextGen(ref Board board) {
    auto boardClone = board.dup();

    for (int i = 0; i < board.height; i++) {
        for (int j = 0; j < board.width; j++) {
            bool cell = boardClone.getCell(i, j);
            int adjacent = 0;

            for (int n = -1; n <= 1; n++) {
                for (int m = -1; m <= 1; m++) {
                    if (n == 0 && m == 0) {
                        continue;
                    }
                    if (boardClone.getCell(i + n, j + m)) {
                        adjacent++;
                    }
                }
            }

            if (cell) {
                if (adjacent < 2) {
                    cell = false;
                }
                if (adjacent > 3) {
                    cell = false;
                }
            } else {
                if (adjacent == 3) {
                    cell = true;
                }
            }

            board.cells[i * board.width + j] = cell;
        }
    }
}

static void runGame(int height, int width, int generations) {
    immutable int size = height*width;
    bool[] cells = new bool[size];

    for (int i = 0; i < height*width; i++) {
        cells[i] = dice(50, 50) == 1;
    }

    auto board = new Board(height, width, cells);

    for (int i = 0; i < generations; i++) {
        board.draw();
        writef("\x1b[%dA", board.height);
        nextGen(board);
    }
}