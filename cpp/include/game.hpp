#pragma once
#include <vector>

void runGame(int height, int width, int generations);

void nextGen(std::vector<bool> &cells, const int &height, const int &width);

bool getCell(const std::vector<bool> &cells, const int &row, const int &col, const int &height, const int &width);

void drawScreen(const std::vector<bool> &cells, const int &height, const int &width);
