#ifndef __GAME_OF_LIFE_H
#define __GAME_OF_LIFE_H

#include <stdbool.h>

void run_game(int height, int width, int generations);
void next_gen(bool cells[], const int* height, const int* width);
bool get_cell(const bool cells[], const int row, const int col, const int* height, const int* width);
void draw_screen(const bool cells[], const int* height, const int* width);

#endif