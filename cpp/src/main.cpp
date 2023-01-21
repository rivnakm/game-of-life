#include "game.hpp"

int main(int argc, char* argv[]) {
    const int generations = 500;
    const int height = 50;
    const int width = 100;

    runGame(height, width, generations);

    return 0;
}