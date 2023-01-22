package gameoflife;

public class App {

    public static void main(String[] args) {
        final int height = 50;
        final int width = 100;
        final int generations = 500;

        Board board = new Board(height, width);
        Game game = new Game(board, generations);
        game.Run();
    }
}
