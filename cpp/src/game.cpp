#include <cstdlib>
#include <ctime>
#include <iostream>
#include <vector>

#include "game.hpp"

void runGame(int height, int width, int generations) {
    std::vector<bool> cells;
    std::srand(std::time(nullptr));
    for (int i = 0; i < height * width; i++) {
        cells.push_back(std::rand() % 2 > 0.5);
    }

    for (int i = 0; i < generations; i++) {
        drawScreen(cells, height, width);
        std::cout << "\x1b[" << height << "A";
        nextGen(cells, height, width);
    }
}

void nextGen(std::vector<bool> &cells, const int &height, const int &width) {
    std::vector<bool> cellsClone(cells);

    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            bool cell = getCell(cellsClone, i, j, height, width);
            int adjacent = 0;

            for (int n = -1; n <= 1; n++) {
                for (int m = -1; m <= 1; m++) {
                    if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
                        continue;
                    }
                    adjacent += int(getCell(cellsClone, i + n, j + m, height, width));
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

            cells[i * width + j] = cell;
        }
    }
}

bool getCell(const std::vector<bool> &cells, const int &row, const int &col, const int &height, const int &width) {
    if (row >= 0 && col >= 0 && row < height && col < width) {
        return cells[(row * width) + col];
    } else {
        return false;
    }
}

void drawScreen(const std::vector<bool> &cells, const int &height, const int &width) {
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            if (cells[(i * width) + j]) {
                std::cout << "██";
            } else {
                std::cout << "  ";
            }
        }
        std::cout << std::endl;
    }
}