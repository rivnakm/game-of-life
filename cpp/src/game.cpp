#include <iostream>

#include "board.hpp"
#include "game.hpp"

void nextGen(Board &board) {
    Board boardClone = board;

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

void runGame(int height, int width, int generations) {
    Board board = Board(height, width);

    for (int i = 0; i < generations; i++) {
        board.draw();
        std::cout << "\x1b[" << board.height << "A";
        nextGen(board);
    }
}
