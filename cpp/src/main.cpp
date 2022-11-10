#include <argparse/argparse.hpp>
#include <iostream>
#include <regex>

#include <sys/ioctl.h>
#include <unistd.h>

#include "game.hpp"

int main(int argc, char* argv[]) {
    argparse::ArgumentParser program("test");

    program.add_argument("--size").help("Screen size [WxH]");
    program.add_argument("--generations").help("Number of generations to run");

    try {
        program.parse_args(argc, argv);
    } catch (const std::runtime_error &err) {
        std::cerr << err.what() << std::endl;
        std::cerr << program;
        std::exit(1);
    }

    int height;
    int width;
    if (program.is_used("--size")) {
        std::regex re("^(\\d+)x(\\d+)");
        std::cmatch match;
        if (std::regex_search(program.get<std::string>("--size").c_str(), match, re)) {
            width = stoi(match[1]);
            height = stoi(match[2]);
        } else {
            std::cerr << "Invalid size '" << program.get<std::string>("--size") << "'" << std::endl;
            std::exit(1);
        }
    } else {
        struct winsize size;
        ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);
        height = size.ws_row - 1;
        width = size.ws_col / 2;
    }

    int generations = -1;
    if (program.is_used("--generations")) {
        generations = stoi(program.get<std::string>("--generations"));
    }

    runGame(height, width, generations);

    return 0;
}