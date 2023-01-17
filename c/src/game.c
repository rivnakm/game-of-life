#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "game.h"

void run_game(int height, int width, int generations) {
    int size = height * width;
    bool* cells = (bool*) malloc(size * sizeof(bool));

    time_t t;
    srand((unsigned)time(&t));
    for (int i = 0; i < size; i++) {
        cells[i] = (rand() % 2 > 0.5);
    }

    for (int i = 0; i < generations; i++) {
        draw_screen(cells, &height, &width);
        printf("\x1b[%dA", height);
        next_gen(cells, &height, &width);
    }
}

void next_gen(bool cells[], const int *height, const int *width) {
    bool* cells_copy = (bool*) malloc(*height * *width * sizeof(bool));
    for (int i = 0; i < *height * *width; i++) {
        cells_copy[i] = cells[i];
    }

    for (int i = 0; i < *height; i++) {
        for (int j = 0; j < *width; j++) {
            bool cell = get_cell(cells_copy, i, j, height, width);
            int adjacent = 0;

            for (int n = -1; n <= 1; n++) {
                for (int m = -1; m <= 1; m++) {
                    if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
                        continue;
                    }
                    adjacent += get_cell(cells_copy, i + n, j + m, height, width);
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

            cells[i * *width + j] = cell;
        }
    }

    free(cells_copy);
}

bool get_cell(const bool cells[], const int row, const int col, const int *height, const int *width) {
    if (row >= 0 && col >= 0 && row < *height && col < *width) {
        return cells[(row * *width) + col];
    } else {
        return false;
    }
}

void draw_screen(const bool cells[], const int *height, const int *width) {
    for (int i = 0; i < *height; i++) {
        for (int j = 0; j < *width; j++) {
            if (cells[(i * *width) + j]) {
                printf("██");
            } else {
                printf("  ");
            }
        }
        printf("\n");
    }
}
