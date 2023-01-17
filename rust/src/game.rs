pub fn run_game(height: usize, width: usize, generations: u32) {
    let screen = Screen {
        height: height,
        width: width,
    };

    let mut cells: Vec<bool> = Vec::with_capacity(screen.size_1d());
    for _ in 0..screen.size_1d() {
        cells.push(rand::random::<bool>());
    }

    for _ in 0..generations {
        screen.draw(&cells);
        print!("\x1b[{}A", screen.height); // Move cursor up
        next_gen(&mut cells, &screen.height, &screen.width);
    }
}

fn next_gen(cells: &mut Vec<bool>, height: &usize, width: &usize) {
    let cells_clone = cells.clone();

    for i in 0..*height {
        for j in 0..*width {
            let mut cell = get_cell(&cells_clone, &i, &j, &height, &width);
            let mut adjacent: u8 = 0;

            for n in 0..3 {
                for m in 0..3 {
                    // avoid unsigned int overflow and ignore center cell
                    if (n == 0 && i == 0) || (m == 0 && j == 0) || (n == 1 && m == 1) {
                        continue;
                    }
                    adjacent +=
                        get_cell(&cells_clone, &(i + n - 1), &(j + m - 1), &height, &width) as u8;
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

            cells[(i * width) + j] = cell
        }
    }
}

fn get_cell(cells: &Vec<bool>, row: &usize, col: &usize, height: &usize, width: &usize) -> bool {
    if row < height && col < width {
        cells[(*row * *width) + *col]
    } else {
        false
    }
}
struct Screen {
    height: usize,
    width: usize,
}

impl Screen {
    fn draw(&self, cells: &Vec<bool>) {
        for i in 0..self.height {
            for j in 0..self.width {
                if cells[(i * self.width) + j] {
                    print!("██");
                } else {
                    print!("  ");
                }
            }
            println!("");
        }
    }

    fn size_1d(&self) -> usize {
        self.height * self.width
    }
}
