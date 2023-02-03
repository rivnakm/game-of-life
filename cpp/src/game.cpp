#include <cstdlib>
#include <ctime>
#include <iostream>
#include <vector>

#include "game.hpp"

typedef struct {
    std::vector<bool> cells;
    int height;
    int width;
} Board;

bool getCell(const Board &board, const int &row, const int &col) {
    if (row >= 0 && col >= 0 && row < board.height && col < board.width) {
        return board.cells[(row * board.width) + col];
    } else {
        return false;
    }
}

void nextGen(Board &board) {
    Board boardClone = {std::vector<bool>(board.cells), board.height, board.width};

    for (int i = 0; i < board.height; i++) {
        for (int j = 0; j < board.width; j++) {
            bool cell = getCell(boardClone, i, j);
            int adjacent = 0;

            for (int n = -1; n <= 1; n++) {
                for (int m = -1; m <= 1; m++) {
                    if (n == 0 && m == 0) {
                        continue;
                    }
                    adjacent += int(getCell(boardClone, i + n, j + m));
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

void drawScreen(const Board &board) {
    for (int i = 0; i < board.height; i++) {
        for (int j = 0; j < board.width; j++) {
            if (board.cells[(i * board.width) + j]) {
                std::cout << "██";
            } else {
                std::cout << "  ";
            }
        }
        std::cout << std::endl;
    }
}

void runGame(int height, int width, int generations) {
    Board board = {std::vector<bool>(), height, width};
    
    std::srand(std::time(nullptr));
    for (int i = 0; i < height * width; i++) {
        board.cells.push_back(std::rand() % 2 > 0.5);
    }

    for (int i = 0; i < generations; i++) {
        drawScreen(board);
        std::cout << "\x1b[" << board.height << "A";
        nextGen(board);
    }
}
