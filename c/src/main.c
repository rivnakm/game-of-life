#include <stdlib.h>
#include <getopt.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "game.h"

int main(int argc, char *argv[]) {
    int opt;

    int generations = -1;
    int height = -1;
    int width = -1;

    while ((opt = getopt(argc, argv, ":g:h:w:")) != -1) {
        switch (opt) {
        case 'g':
            generations = atoi(optarg);
            break;
        case 'h':
            height = atoi(optarg);
            break;
        case 'w':
            width = atoi(optarg);
            break;
        }
    }

    if (height == -1 && width == -1) {
        struct winsize size;
        ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);
        height = size.ws_row - 1;
        width = size.ws_col / 2;
    } else if (height != -1 && width != -1) {
        // Looks good
    } else {
        fprintf(stderr, "Both height and width (or neither) must be specified\n");
        return 1;
    }

    run_game(height, width, generations);

    return 0;
}