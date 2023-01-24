package gameoflife;

public class Game {
    private Board board;
    private int generations;

    public Game(Board board, int generations) {
        this.board = board;
        this.generations = generations;
    }

    public void run() {
        for (int i = 0; i < this.generations; i++) {
            this.board.draw();
            System.out.print("\033[" + String.valueOf(this.board.getHeight()) + "A");
            this.next();
        }
    }

    private void next() {
        Board boardCopy = new Board(this.board);
        for (int i = 0; i < this.board.getHeight(); i++) {
            for (int j = 0; j < this.board.getWidth(); j++) {
                boolean cell = boardCopy.getCell(i, j);

                int adjacent = 0;
                for (int n = -1; n <= 1; n++) {
                    for (int m = -1; m <= 1; m++) {
                        if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
                            continue;
                        }
                        if (boardCopy.getCell(i + n, j + m))
                            adjacent++;
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

                this.board.setCell((i * this.board.getWidth()) + j, cell);
            }
        }
    }
}