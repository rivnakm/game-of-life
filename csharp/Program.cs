namespace GameOfLife
{
    internal class Game
    {
        private Board board { get; }
        private int generations { get; }

        public Game(Board board, int generations)
        {
            this.board = board;

            this.generations = generations;
        }

        public void Run()
        {
            for (var i = 0; i < this.generations; i++)
            {
                this.board.Draw();
                Console.Write($"\x1b[{this.board.height}A");
                this.Next();
            }
        }

        private void Next()
        {
            var boardCopy = new Board(board);
            for (var i = 0; i < this.board.height; i++)
            {
                for (var j = 0; j < this.board.width; j++)
                {
                    var cell = boardCopy.GetCell(i, j);

                    var adjacent = 0;
                    for (var n = -1; n <= 1; n++)
                    {
                        for (var m = -1; m <= 1; m++)
                        {
                            if (n == 0 && m == 0)
                            {
                                continue;
                            }
                            if (boardCopy.GetCell(i + n, j + m))
                                adjacent++;
                        }
                    }

                    if (cell)
                    {
                        if (adjacent < 2)
                        {
                            cell = false;
                        }
                        if (adjacent > 3)
                        {
                            cell = false;
                        }
                    }
                    else
                    {
                        if (adjacent == 3)
                        {
                            cell = true;
                        }
                    }

                    this.board.cells[(i * this.board.width) + j] = cell;
                }
            }
        }
    }
    public class GameOfLife
    {
        static void Main(string[] args)
        {
            int height = 50;
            int width = 100;
            int generations = 500;

            Board board = new(height, width);
            Game game = new(board, generations);
            game.Run();
        }
    }
}
