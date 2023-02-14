module game;

import std.container;
import std.random;
import std.stdio;

struct Board {
    Array!bool cells;
    int height;
    int width;
}

static bool getCell(ref Board board, int row, int col) {
    if (row >= 0 && col >= 0 && row < board.height && col < board.width) {
        return board.cells[(row * board.width) + col];
    } else {
        return false;
    }
}

static void nextGen(ref Board board) {
    auto boardClone = Board(board.cells.dup(), board.height, board.width);

    for (int i = 0; i < board.height; i++) {
        for (int j = 0; j < board.width; j++) {
            bool cell = getCell(boardClone, i, j);
            int adjacent = 0;

            for (int n = -1; n <= 1; n++) {
                for (int m = -1; m <= 1; m++) {
                    if (n == 0 && m == 0) {
                        continue;
                    }
                    if (getCell(boardClone, i + n, j + m)) {
                        adjacent++;
                    };
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

static void drawScreen(ref Board board) {
    for (int i = 0; i < board.height; i++) {
        for (int j = 0; j < board.width; j++) {
            if (board.cells[(i * board.width) + j]) {
                write("██");
            } else {
                write("  ");
            }
        }
        writeln();
    }
}

static void runGame(int height, int width, int generations) {
    Array!bool cells;

    for (int i = 0; i < height*width; i++) {
        cells.insertBack(dice(50, 50) == 1);
    }

    Board board = Board(cells, height, width);

    for (int i = 0; i < generations; i++) {
        drawScreen(board);
        writef("\x1b[%dA", board.height);
        nextGen(board);
    }
}