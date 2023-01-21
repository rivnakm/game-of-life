import "dart:io";
import "dart:math";

class Board {
  late List<bool> cells;
  late int height;
  late int width;

  Board(int height, int width) {
    this.height = height;
    this.width = width;
  }

  int size() {
    return this.height * this.width;
  }
}

void runGame(int height, int width, int generations) {
  final rng = Random();
  Board board = new Board(height, width);
  board.cells = List<bool>.generate(height*width, (index) => rng.nextBool());

  for (int i = 0; i < generations; i++) {
    drawScreen(board);
    stdout.write("\x1b[${height}A");
    nextGeneration(board);
  }
}

bool getCell(Board board, int row, int col) {
  if (row >= 0 && col >= 0 && row < board.height && col < board.width) {
    return board.cells[(row*board.width)+col];
  }
  else {
    return false;
  }
}

void nextGeneration(Board board) {
  Board boardCopy = new Board(board.height, board.width);
  boardCopy.cells = List<bool>.from(board.cells);

  for (int i = 0; i < board.height; i++) {
    for (int j = 0; j < board.width; j++) {
      bool cell = getCell(boardCopy, i, j);
      int adjacent = 0;

      for (int n = -1; n <= 1; n++) {
        for (int m = -1; m <= 1; m++) {
          if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
            continue;
          }
          if (getCell(boardCopy, i+n, j+m)) {
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
      }
      else {
        if (adjacent == 3) {
          cell = true;
        }
      }

      board.cells[(i*board.width)+j] = cell;
    }
  }
}

void drawScreen(Board board) {
  for (int i = 0; i < board.height; i++) {
    for (int j = 0; j < board.width; j++) {
      if (board.cells[(i*board.width)+j]) {
        stdout.write("██");
      }
      else {
        stdout.write("  ");
      }
    }
    print("");
  }
}