use std::io::{self, Write};

use rand::Rng;

#[inline(always)]
pub fn run_game<const HEIGHT: usize, const WIDTH: usize, const GENERATIONS: u32>() {
    let size = WIDTH * HEIGHT;

    const CLEAR_PRE: &str = "\x1b[";
    const CLEAR_SUF: &str = "A";

    let clear_len = CLEAR_PRE.len() + HEIGHT.ilog10() as usize + 1 + CLEAR_SUF.len();

    let cap = {
        // Space for clear
        clear_len +
        // Space for all cells
        size * 6 +
        // Space for newlines
        HEIGHT
    };

    let mut buf = unsafe {
        // Manually allocate the vector, to REALLY make sure it doesn't allocate any excess
        // capacity
        let layout = std::alloc::Layout::array::<u8>(cap).unwrap_unchecked();
        let ptr = std::alloc::alloc(layout);
        if ptr.is_null() {
            std::alloc::handle_alloc_error(layout)
        };
        let mut buf = Vec::from_raw_parts(ptr, 0, cap);
        let _ = write!(&mut buf, "\x1b[{HEIGHT}A");
        buf
    };

    let mut screen = Screen::<WIDTH, HEIGHT>::new();
    let mut stdout = io::stdout().lock();
    // // Clear screen once at the start
    // let _ = stdout.write_all(b"\x1bc");
    for _ in 0..GENERATIONS {
        screen.draw(&mut buf);
        let _ = stdout.write_all(&buf);
        let _ = stdout.flush();
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
        *self.cells.get_unchecked(idx)
    }

    #[inline(always)]
    unsafe fn get_cell_unchecked_mut(&mut self, row: usize, col: usize) -> &mut bool {
        let idx = row * WIDTH + col;
        debug_assert!(row < HEIGHT && col < WIDTH, "OOB access");
        self.swap.get_unchecked_mut(idx)
    }

    #[allow(dead_code)]
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
        let right = WIDTH - 1;
        macro_rules! adjacent {
            ($([$row:expr, $col:expr]),* $(,)?) => {{
                0 $(
                    + self.get_cell_unchecked($row, $col) as u8
                )*
            }};
        }
        macro_rules! cell {
            (($row:expr, $col:expr)) => {
                let cell = self.get_cell_unchecked($row, $col);
                let adjacent = adjacent! {
                    [$row - 1, $col - 1],
                    [$row - 1, $col],
                    [$row - 1, $col + 1],
                    [$row, $col - 1],
                    [$row, $col + 1],
                    [$row + 1, $col - 1],
                    [$row + 1, $col],
                    [$row + 1, $col + 1]
                };
                *self.get_cell_unchecked_mut($row, $col) = lives(cell, adjacent);
            };
            (($row:expr, $col:expr),
             [
                $topl:expr, $topm:expr, $topr:expr,
                $midl:expr, _____, $midr:expr,
                $botl:expr, $botm:expr, $botr:expr $(,)?
             ]
             ) => {
                let cell = self.get_cell_unchecked($row, $col);
                let adjacent = if $topl {
                    self.get_cell_unchecked($row - 1, $col - 1) as u8
                } else {
                    0
                } + if $topm {
                    self.get_cell_unchecked($row - 1, $col) as u8
                } else {
                    0
                } + if $topr {
                    self.get_cell_unchecked($row - 1, $col + 1) as u8
                } else {
                    0
                } + if $midl {
                    self.get_cell_unchecked($row, $col - 1) as u8
                } else {
                    0
                } + if $midr {
                    self.get_cell_unchecked($row, $col + 1) as u8
                } else {
                    0
                } + if $botl {
                    self.get_cell_unchecked($row + 1, $col - 1) as u8
                } else {
                    0
                } + if $botm {
                    self.get_cell_unchecked($row + 1, $col) as u8
                } else {
                    0
                } + if $botr {
                    self.get_cell_unchecked($row + 1, $col + 1) as u8
                } else {
                    0
                };
                *self.get_cell_unchecked_mut($row, $col) = lives(cell, adjacent);
            };
        }
        unsafe {
            // First row
            // Top left cell
            cell! {
                (0, 0),
                [
                    false, false, false,
                    false, _____, true,
                    false, true,  true
                ]
            };
            // Top middle cells
            // These cells can look for neighbours in all directions but up
            for col in 1..right {
                cell! {
                    (0, col),
                    [
                        false, false, false,
                        true,  _____, true,
                        true,  true,  true
                    ]
                };
            }

            // Top right cell
            cell! {
                (0, right),
                [
                    false, false, false,
                    true,  _____, false,
                    true,  true,  false
                ]
            };
            // Middle rows
            for row in 1..HEIGHT - 1 {
                // First column
                // can access all neighbours not to the left
                cell! {
                    (row, 0),
                    [
                        false, true,  true,
                        false, _____, true,
                        false, true,  true
                    ]
                };
                // Middle columns
                // can access all neighbours
                for col in 1..right {
                    cell!((row, col));
                }

                // Last column
                // can access all neighbours not to the right
                cell! {
                    (row, right),
                    [
                        true, true,  false,
                        true, _____, false,
                        true, true,  false,
                    ]
                };
            }
            let bottom_row = HEIGHT - 1;
            // Bottom row
            // Bottom left cell
            cell! {
                (bottom_row, 0),
                [
                    false, true,  true,
                    false, _____, true,
                    false, false, false,
                ]
            };

            // Bottom middle cells
            // These cells can look for neighbours in all directions but down
            for col in 1..right {
                cell! {
                    (bottom_row, col),
                    [
                        true, true, true,
                        true, _____, true,
                        false, false, false,
                    ]
                };
            }

            // Bottom right cell
            cell! {
                (bottom_row, right),
                [
                    true,  true,  false,
                    true,  _____, false,
                    false, false, false,
                ]
            };
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
    #[allow(dead_code)]
    fn draw(&self, buf: &mut Vec<u8>) {
        for line in self.cells.chunks_exact(WIDTH) {
            unsafe {
                Self::write_line(buf, line);
            }
        }
    }
}
