namespace GameOfLife {
    internal class Board {
        public IList<bool> cells { get; }
        public int height { get; }
        public int width { get; }

        public Board(int height, int width) {
            this.cells = new List<bool>();
            this.height = height;
            this.width = width;

            Random random = new();
            for (var i = 0; i < this.height * this.width; i++)
            {
                cells.Add(random.Next(2) == 1);
            }
        }

        public Board(Board other) {
            this.cells = new List<bool>(other.cells);
            this.height = other.height;
            this.width = other.width;
        }

        public void Draw() {
            for (var i = 0; i < this.height; i++) {
                for (var j = 0; j < this.width; j++) {
                    if (this.cells[(i * this.width) + j]) {
                        Console.Write("██");
                    }
                    else {
                        Console.Write("  ");
                    }
                }
                Console.WriteLine();
            }
        }

        public bool GetCell(int row, int col)
        {
            if (row >= 0 && row < this.height && col >= 0 && col < this.width)
            {
                return this.cells[(row * this.width) + col];
            }
            else
            {
                return false;
            }
        }
    }
}