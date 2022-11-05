namespace GameOfLife {
    internal class Screen {
        public int height { get; }
        public int width { get; }

        public int size1D { get {
            return this.height * this.width;
        }}
        public Screen(int height, int width) {
            this.height = height;
            this.width = width;
        }

        public void Draw(IList<bool> cells) {
            for (var i = 0; i < this.height; i++) {
                for (var j = 0; j < this.width; j++) {
                    if (cells[(i * this.width) + j]) {
                        Console.Write("██");
                    }
                    else {
                        Console.Write("  ");
                    }
                }
                Console.WriteLine();
            }
        }
    }
}