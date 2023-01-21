pub fn run_game(height: usize, width: usize, generations: u32) {
    
    let mut board = Board::new(height, width);


    for _ in 0..generations {
        board.draw();
        print!("\x1b[{}A", board.height); // Move cursor up
        next_gen(&mut board);
    }
}

fn next_gen(board: &mut Board) {
    let board_clone = board.clone();

    for i in 0..board.height {
        for j in 0..board.width {
            let mut cell = board_clone.get_cell(&i, &j);
            let mut adjacent: u8 = 0;

            for n in 0..3 {
                for m in 0..3 {
                    // avoid unsigned int overflow and ignore center cell
                    if (n == 0 && i == 0) || (m == 0 && j == 0) || (n == 1 && m == 1) {
                        continue;
                    }
                    if board_clone.get_cell(&(i + n - 1), &(j + m - 1)) {
                        adjacent += 1;
                    }
                }
            }

            if cell {
                if adjacent < 2 {
                    cell = false;
                }
                if adjacent > 3 {
                    cell = false;
                }
            } else {
                if adjacent == 3 {
                    cell = true
                }
            }

            board.cells[(i * board.width) + j] = cell
        }
    }
}

#[derive(Clone)]
struct Board {
    cells: Vec<bool>,
    height: usize,
    width: usize,
}

impl Board {
    fn new(height: usize, width: usize) -> Board {
        let mut cells: Vec<bool> = Vec::with_capacity(height*width);
        for _ in 0..height*width {
            cells.push(rand::random::<bool>());
        }

        Board {
            cells: cells,
            height: height,
            width: width,
        }
    }

    fn get_cell(&self, row: &usize, col: &usize) -> bool {
        if *row < self.height && *col < self.width {
            self.cells[(*row * self.width) + *col]
        } else {
            false
        }
    }

    fn draw(&self) {
        for i in 0..self.height {
            for j in 0..self.width {
                if self.cells[(i * self.width) + j] {
                    print!("██");
                } else {
                    print!("  ");
                }
            }
            println!("");
        }
    }
}
