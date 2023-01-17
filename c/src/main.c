#include "game.h"

int main(int argc, char *argv[]) {
    int opt;

    int generations = 500;
    int height = 50;
    int width = 100;

    run_game(height, width, generations);

    return 0;
}