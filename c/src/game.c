#include "lookup.c"
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

typedef struct {
    bool  *cells;
    bool  *swap;
    size_t height;
    size_t width;
} Board;

// static bool get_cell(const Board *board, const size_t row, const size_t col) {
//     if (row >= 0 && col >= 0 && row < board->height && col < board->width) {
//         return board->cells[row * board->width + col];
//     } else {
//         return false;
//     }
// }
static bool get_cell_unchecked(const Board *board, const size_t row, const size_t col) {
    return board->cells[row * board->width + col];
}

static void next_gen(Board *board) {
#define LIVES(cell, adjacent) ((adjacent == 3) | (cell && adjacent == 2));
#define CELL(row, col, tl, tm, tr, ml, mr, bl, bm, br)                    \
    {                                                                     \
        bool cell     = get_cell_unchecked(board, row, col);              \
        int  adjacent = 0;                                                \
        if (tl) {                                                         \
            adjacent += get_cell_unchecked(board, row - 1, col - 1);      \
        };                                                                \
        if (tm) {                                                         \
            adjacent += get_cell_unchecked(board, row - 1, col);          \
        };                                                                \
        if (tr) {                                                         \
            adjacent += get_cell_unchecked(board, row - 1, col + 1);      \
        };                                                                \
        if (ml) {                                                         \
            adjacent += get_cell_unchecked(board, row, col - 1);          \
        };                                                                \
        if (mr) {                                                         \
            adjacent += get_cell_unchecked(board, row, col + 1);          \
        };                                                                \
        if (bl) {                                                         \
            adjacent += get_cell_unchecked(board, row + 1, col - 1);      \
        };                                                                \
        if (bm) {                                                         \
            adjacent += get_cell_unchecked(board, row + 1, col);          \
        };                                                                \
        if (br) {                                                         \
            adjacent += get_cell_unchecked(board, row + 1, col + 1);      \
        };                                                                \
        board->swap[(board->width) * (row) + col] = LIVES(cell, adjacent) \
    }                                                                     \
    // clang-format off
    // Top row
    CELL(0ul, 0ul,
        false, false, false,
        false,        true,
        false, true,  true
    );
    for (size_t col = 1; col < board->width - 1; col++) {
        CELL(0ul, col,
            false, false, false,
            true,         true,
            true,  true,  true
        );
    }
    CELL(0ul, board->width - 1,
        false, false, false,
        true,         false,
        true,  true,  false
    );
    // Middle row
    for (size_t row = 1; row < board->height - 1; row++) {
        CELL(row, 0ul,
            false, true,  true,
            false,        true,
            false, true,  true
        );
        for (size_t col = 1; col < board->width - 1; col++) {
            CELL(row, col,
            true,  true,  true,
            true,         true,
            true,  true,  true
            )
        }
        CELL(row, board->width - 1,
            true,  true,  false,
            true,         false,
            true,  true,  false
        );
    }
    // Bottom row
    CELL(board->height - 1, 0ul,
        false, true,  true,
        false,        true,
        false, false, false
    );
    for (size_t col = 1; col < board->width - 1; col++) {
        CELL(
            board->height - 1, col,
            true,  true,  true,
            true,         true,
            false, false, false
        );
    }

    // Bottom right cell
    CELL(
        board->height - 1, board->width - 1,
        true,  true,  false,
        true,         false,
        false, false, false
    );
    // clang-format on

    bool *temp   = board->cells;
    board->cells = board->swap;
    board->swap  = temp;
}

static size_t draw_screen(const Board *board, char *buf) {
    char *start = buf;
#define ALIVE     "██"
#define ALIVE_LEN 6
#define DEAD      "  "
#define DEAD_LEN  2
    for (size_t i = 0; i < board->height; i++) {
        size_t j = 0;
        while (j + 8 < board->width) {
            unsigned char pattern = 0;
            for (size_t offset = 0; offset < 8; offset++)
                pattern |= ((unsigned char)board->cells[(i * board->width) + j++]) << offset;
            length_str out = STRINGS[pattern];
            memcpy(buf, out.str, out.len);
            buf += out.len;
        }
        for (; j < board->width; j++) {
            if (board->cells[(i * board->width) + j]) {
                memcpy(buf, ALIVE, ALIVE_LEN);
                buf += ALIVE_LEN;
            } else {
                memcpy(buf, DEAD, DEAD_LEN);
                buf += DEAD_LEN;
            }
        }
        *(buf++) = '\n';
    }
    return (size_t)(buf - start);
}

void run_game(size_t height, size_t width, int generations) {
    size_t size  = (size_t)(height * width);
    bool  *cells = (bool *)malloc(size * sizeof(bool));
    bool  *swap  = (bool *)malloc(size * sizeof(bool));
    Board  board = {cells, swap, height, width};

    char clear[64];
    sprintf(clear, "\x1b[%zuA", height);
    size_t clearlen = strlen(clear);
    char  *buf      = (char *)malloc(clearlen
                                     // Space for all cells
                                     + size * 6
                                     // Space for newlines
                                     + (size_t)height);
    memcpy(buf, clear, clearlen);
    char *bufactive = buf + clearlen;

    time_t t;
    srand((unsigned)time(&t));
    for (size_t i = 0; i < size; i++) {
        board.cells[i] = (rand() % 2 > 0.5);
    }

    for (int i = 0; i < generations; i++) {
        size_t written = draw_screen(&board, bufactive);
        fwrite(buf, 1, written + clearlen, stdout);
        next_gen(&board);
    }
    free(board.cells);
    free(board.swap);
    free(buf);
}
