import "dart:io";
import "dart:math";

void runGame(int height, int width, int generations) {
  final rng = Random();
  List<bool> cells = List<bool>.generate(height*width, (index) => rng.nextBool());

  if (generations == -1) {
    while (true) {
      drawScreen(cells, height, width);
      stdout.write("\x1b[${height}A");
      nextGeneration(cells, height, width);
    }
  }
  else {
    for (int i = 0; i < generations; i++) {
      drawScreen(cells, height, width);
      stdout.write("\x1b[${height}A");
      nextGeneration(cells, height, width);
    }
  }
}

bool getCell(List<bool> cells, int row, int col, int height, int width) {
  if (row >= 0 && col >= 0 && row < height && col < width) {
    return cells[(row*width)+col];
  }
  else {
    return false;
  }
}

void nextGeneration(List<bool> cells, int height, int width) {
  final cellsCopy = List<bool>.from(cells);

  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      bool cell = getCell(cellsCopy, i, j, height, width);
      int adjacent = 0;

      for (int n = -1; n <= 1; n++) {
        for (int m = -1; m <= 1; m++) {
          if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
            continue;
          }
          adjacent += getCell(cellsCopy, i+n, j+m, height, width) ? 1 : 0;
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

      cells[(i*width)+j] = cell;
    }
  }
}

void drawScreen(List<bool> cells, int height, int width) {
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      if (cells[(i*width)+j]) {
        stdout.write("██");
      }
      else {
        stdout.write("  ");
      }
    }
    print("");
  }
}