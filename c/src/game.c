#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "game.h"

typedef struct {
    bool* cells;
    int height;
    int width;
} Board;

static bool get_cell(const Board const * board, const int row, const int col) {
    if (row >= 0 && col >= 0 && row < board->height && col < board->width) {
        return board->cells[(row * board->width) + col];
    } else {
        return false;
    }
}

static void next_gen(Board* board) {
    bool* cells_copy = (bool*) malloc(board->height * board->width * sizeof(bool));
    memcpy(cells_copy, board->cells, (board->height) * (board->width) * sizeof(bool));

    Board board_copy = {cells_copy, board->height, board->width};

    for (int i = 0; i < board->height; i++) {
        for (int j = 0; j < board->width; j++) {
            bool cell = get_cell(&board_copy, i, j);
            int adjacent = 0;

            for (int n = -1; n <= 1; n++) {
                for (int m = -1; m <= 1; m++) {
                    if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
                        continue;
                    }
                    if (get_cell(&board_copy, i + n, j + m)) {
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

            board->cells[i * board->width + j] = cell;
        }
    }

    free(cells_copy);
}

static void draw_screen(const Board const * board) {
    for (int i = 0; i < board->height; i++) {
        for (int j = 0; j < board->width; j++) {
            if (board->cells[(i * board->width) + j]) {
                printf("██");
            } else {
                printf("  ");
            }
        }
        printf("\n");
    }
}

void run_game(int height, int width, int generations) {
    int size = height * width;
    bool* cells = (bool*) malloc(size * sizeof(bool));

    Board board = {cells, height, width};

    time_t t;
    srand((unsigned)time(&t));
    for (int i = 0; i < size; i++) {
        board.cells[i] = (rand() % 2 > 0.5);
    }

    for (int i = 0; i < generations; i++) {
        draw_screen(&board);
        printf("\x1b[%dA", board.height);
        next_gen(&board);
    }
}