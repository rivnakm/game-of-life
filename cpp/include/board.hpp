#include <vector>

class Board {
    public:
        Board(int height, int width);
        Board(const Board &other);

        void draw();
        bool getCell(const int &row, const int &col);

            int height;
        int width;
        std::vector<bool> cells;
};