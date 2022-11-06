#include <argparse/argparse.hpp>
#include <iostream>
#include <regex>

int main(int argc, char *argv[]) {
    std::cout << "Hello, C++!" << std::endl;

    argparse::ArgumentParser program("test");

    program.add_argument("--size").help("Screen size [WxH]");
    program.add_argument("--iterations").help("Number of iterations to run");

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
        }
    }

    return 0;
}