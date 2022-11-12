using System.Text.RegularExpressions;
using CommandLine;

namespace GameOfLife
{
    public class Options
    {
        [Option('s', "size", Required = false, HelpText = "Screen size [WxH]")]
        public string? Size { get; set; }

        [Option('i', "generations", Required = false, HelpText = "Number of generations to run")]
        public int? generations { get; set; }
    }

    internal class Game
    {
        private int height { get; set; }
        private int width { get; set; }

        private Screen screen { get; }
        private int generations { get; }
        private IList<bool> cells { get; set; }

        public Game(Screen screen, int generations)
        {
            this.screen = screen;
            this.generations = generations;
            this.cells = new List<bool>();

            this.height = this.screen.height;
            this.width = this.screen.width;

            Random random = new();
            for (var i = 0; i < this.screen.size1D; i++)
            {
                cells.Add(random.Next(2) == 1);
            }
        }

        public void Run()
        {
            if (generations == -1)
            {
                while (true)
                {
                    screen.Draw(cells);
                    Console.SetCursorPosition(0, 0);
                    this.Next();
                }
            }
            else
            {
                for (var i = 0; i < this.generations; i++)
                {
                    screen.Draw(cells);
                    Console.SetCursorPosition(0, 0);
                    this.Next();
                }
            }
        }

        private void Next()
        {
            var cellsCopy = new List<bool>(this.cells);
            for (var i = 0; i < this.height; i++)
            {
                for (var j = 0; j < this.width; j++)
                {
                    var cell = this.GetCell(this.cells, i, j);

                    var adjacent = 0;
                    for (var n = -1; n <= 1; n++)
                    {
                        for (var m = -1; m <= 1; m++)
                        {
                            if ((n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)) {
                                continue;
                            }
                            adjacent += GetCell(cellsCopy, i + n, j + m) ? 1 : 0;
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

                    this.cells[(i * width) + j] = cell;
                }
            }
        }

        private bool GetCell(IList<bool> items, int row, int col)
        {
            if (row >= 0 && row < this.height && col >= 0 && col < this.width)
            {
                return items[(row * this.width) + col];
            }
            else
            {
                return false;
            }
        }
    }
    public class GameOfLife
    {
        static void Main(string[] args)
        {
            int columns = Console.WindowWidth / 2;
            int lines = Console.WindowHeight - 1;
            int generations = -1;
            var result = CommandLine.Parser.Default.ParseArguments<Options>(args).WithParsed<Options>(o =>
            {
                if (o.Size != null)
                {
                    var size = (string)o.Size;
                    Regex re = new(@"(\d+)x(\d+)");
                    var match = re.Match(size);
                    columns = int.Parse(match.Groups[1].Value);
                    lines = int.Parse(match.Groups[2].Value);
                }
                if (o.generations != null)
                {
                    generations = (int)o.generations;
                }
            });

            Screen screen = new(lines, columns);
            Game game = new(screen, generations);
            game.Run();
        }
    }
}
