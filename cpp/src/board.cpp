#include <cstdlib>
#include <ctime>
#include <iostream>
#include <vector>

#include "board.hpp"

Board::Board(int height, int width) {
    this->height = height;
    this->width = width;
    this->cells = std::vector<bool>();

    std::srand(std::time(nullptr));
    for (int i = 0; i < height * width; i++) {
        this->cells.push_back(std::rand() % 2 > 0.5);
    }
}

Board::Board(const Board &other) {
    this->height = other.height;
    this->width = other.width;
    this->cells = std::vector<bool>(other.cells);
}

bool Board::getCell(const int &row, const int &col) {
    if (row >= 0 && col >= 0 && row < this->height && col < this->width) {
        return this->cells[(row * this->width) + col];
    } else {
        return false;
    }
}

void Board::draw() {
    for (int i = 0; i < this->height; i++) {
        for (int j = 0; j < this->width; j++) {
            if (this->cells[(i * this->width) + j]) {
                std::cout << "██";
            } else {
                std::cout << "  ";
            }
        }
        std::cout << std::endl;
    }
}