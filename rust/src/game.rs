use std::io::{self, Write};

use rand::Rng;

#[inline(always)]
pub fn run_game<const HEIGHT: usize, const WIDTH: usize, const GENERATIONS: u32>() {
    let size = WIDTH * HEIGHT;

    let mut buf = format!("\x1b[{}A", HEIGHT).into_bytes();
    let clear_len = buf.len();
    buf.reserve(
        // Space for all cells
        size * 6
        // Space for newlines
        + HEIGHT,
    );

    let mut screen = Screen::<WIDTH, HEIGHT>::new();
    let mut stdout = io::stdout().lock();
    // Clear screen
    let _ = stdout.write_all(b"\x1bc");
    for _ in 0..GENERATIONS {
        screen.draw(&mut buf);
        let _ = stdout.write_all(&buf).and_then(|_| stdout.flush());
        unsafe {
            buf.set_len(clear_len);
        }
        screen.next_gen();
    }
}

#[non_exhaustive]
#[derive(Debug)]
struct Screen<const WIDTH: usize, const HEIGHT: usize> {
    cells: Box<[bool]>,
    swap: Box<[bool]>,
}

use crate::{constant::LOOKUP, trait_ext::UncheckedVecExt};
impl<const WIDTH: usize, const HEIGHT: usize> Screen<WIDTH, HEIGHT> {
    #[inline(always)]
    fn new() -> Self {
        let size = WIDTH * HEIGHT;
        let mut rng = rand::thread_rng();
        let cells: Box<[bool]> = (0..size).map(|_| rng.gen()).collect();

        let swap = cells.clone();
        Self { cells, swap }
    }

    #[inline(always)]
    unsafe fn get_cell_unchecked(&self, row: usize, col: usize) -> bool {
        let idx = row * WIDTH + col;
        debug_assert!(row < HEIGHT && col < WIDTH, "OOB access");
        // eprintln!("Read {idx} | {row},{col}");
        *self.cells.get_unchecked(idx)
    }

    #[inline(always)]
    unsafe fn get_cell_unchecked_mut(&mut self, row: usize, col: usize) -> &mut bool {
        let idx = row * WIDTH + col;
        debug_assert!(row < HEIGHT && col < WIDTH, "OOB access");
        // eprintln!("Wrote to {idx}");
        self.swap.get_unchecked_mut(idx)
    }

    #[inline(always)]
    fn next_gen(&mut self) {
        #[inline(always)]
        fn lives(cell: bool, adjacent: u8) -> bool {
            (adjacent == 3) | (cell && adjacent == 2)
        }
        if WIDTH == 0 || HEIGHT == 0 {
            // Avoid trying to access non-existant cells
            return;
        };
        if HEIGHT == 1 && WIDTH == 1 {
            // There is only a single cell, it can't have neighbours
            self.cells[0] = false;
            return;
        };
        if HEIGHT + WIDTH == 3 {
            // a 2x1 grid only has 2 cells, thus each can only have 1 neighbour, so all cells must
            // die
            self.cells.fill(false);
            return;
        }
        macro_rules! adjacent {
            ($([$row:expr, $col:expr]),* $(,)?) => {{
                0 $(
                    + self.get_cell_unchecked($row, $col) as u8
                )*
            }};
        }
        unsafe {
            // First row
            // Top left cell
            let row = 0;
            let cell = self.get_cell_unchecked(row, 0);
            let adjacent = adjacent! {
                [row + 1, 0],
                [row + 1, 1],
                [row, 1]
            };
            *self.get_cell_unchecked_mut(row, 0) = lives(cell, adjacent);

            // Top middle cells
            // These cells can look for neighbours in all directions but up
            for col in 1..WIDTH - 1 {
                let cell = self.get_cell_unchecked(row, col);
                let adjacent = adjacent! {
                    [row, col - 1],
                    [row, col + 1],
                    [row + 1, col - 1],
                    [row + 1, col],
                    [row + 1, col + 1],
                };
                *self.get_cell_unchecked_mut(row, col) = lives(cell, adjacent);
            }

            // Top right cell(0, WIDTH - 1)
            let cell = self.get_cell_unchecked(row, WIDTH - 1);
            let adjacent = adjacent! {
                [row, WIDTH - 2],
                [row + 1, WIDTH - 2],
                [row + 1, WIDTH - 1],
            };
            *self.get_cell_unchecked_mut(row, WIDTH - 1) = lives(cell, adjacent);
            // Middle rows
            for row in 1..HEIGHT - 1 {
                // First column
                // can access all neighbours not to the left
                let col = 0;
                let cell = self.get_cell_unchecked(row, col);
                let adj = adjacent! {
                    [row - 1, col],
                    [row - 1, col + 1],
                    [row, col + 1],
                    [row + 1, col],
                    [row + 1, col + 1]
                };
                *self.get_cell_unchecked_mut(row, col) = lives(cell, adj);
                // Middle columns
                // can access all neighbours
                for col in 1..WIDTH - 1 {
                    let cell = self.get_cell_unchecked(row, col);
                    let adj = adjacent! {
                        [row - 1, col - 1],
                        [row - 1, col],
                        [row - 1, col + 1],
                        [row, col - 1],
                        [row, col + 1],
                        [row + 1, col - 1],
                        [row + 1, col],
                        [row + 1, col + 1]
                    };
                    *self.get_cell_unchecked_mut(row, col) = lives(cell, adj);
                }

                // Last column
                // can access all neighbours not to the right
                let col = WIDTH - 1;
                let cell = self.get_cell_unchecked(row, col);
                let adjacent = adjacent! {
                    [row - 1, col],
                    [row + 1, col],
                    [row - 1, col - 1],
                    [row    , col - 1],
                    [row + 1, col - 1]
                };
                *self.get_cell_unchecked_mut(row, col) = lives(cell, adjacent);
            }
            let row = HEIGHT - 1;
            // Bottom row
            // Bottom left cell
            let cell = self.get_cell_unchecked(row, 0);
            let adjacent = adjacent! {
                [row, 1],
                [row - 1, 0],
                [row - 1, 1],
            };
            *self.get_cell_unchecked_mut(row, 0) = lives(cell, adjacent);

            // Bottom middle cells
            // These cells can look for neighbours in all directions but down
            for col in 1..WIDTH - 1 {
                let cell = self.get_cell_unchecked(row, col);
                let adjacent = adjacent! {
                    [row, col - 1],
                    [row, col + 1],
                    [row - 1, col - 1],
                    [row - 1, col],
                    [row - 1, col + 1],
                };
                *self.get_cell_unchecked_mut(row, col) = lives(cell, adjacent);
            }

            // Bottom right cell(HEIGHT - 1, WIDTH - 1)
            let cell = self.get_cell_unchecked(row, WIDTH - 1);
            let adjacent = adjacent! {
                [row, WIDTH - 2],
                [row - 1, WIDTH - 2],
                [row - 1, WIDTH - 1],
            };
            *self.get_cell_unchecked_mut(row, WIDTH - 1) = lives(cell, adjacent);
        }
        std::mem::swap(&mut self.cells, &mut self.swap)
    }

    #[inline(always)]
    unsafe fn write_line(buf: &mut Vec<u8>, slice: &[bool]) {
        let mut chunks = slice.chunks_exact(8);
        for chunk in chunks.by_ref() {
            let val: u8 = chunk
                .iter()
                .map(|&b| b as u8)
                .enumerate()
                .map(|(idx, b)| b << idx)
                .fold(0, |acc, b| acc | b);
            unsafe {
                let pattern = LOOKUP.get_unchecked(val as usize);
                buf.extend_from_slice_unchecked(pattern);
            }
        }

        for &cell in chunks.remainder() {
            unsafe {
                buf.extend_from_slice_unchecked(if cell {
                    b"\xE2\x96\x88\xE2\x96\x88"
                } else {
                    b"  "
                });
            }
        }
        unsafe {
            buf.push_unchecked(b'\n');
        }
    }

    #[inline(always)]
    fn draw(&self, buf: &mut Vec<u8>) {
        for line in self.cells.chunks_exact(WIDTH) {
            unsafe {
                Self::write_line(buf, line);
            }
        }
    }
}
