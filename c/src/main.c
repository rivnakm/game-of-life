#include <stdlib.h>
#include <getopt.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "game.h"

int main(int argc, char *argv[]) {
    int opt;

    int generations = 500;
    int height = 50;
    int width = 100;

    run_game(height, width, generations);

    return 0;
}