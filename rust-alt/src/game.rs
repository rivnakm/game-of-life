use crate::{constant::LOOKUP, trait_ext::UncheckedVecExt};
use std::io::{self, Write};

use rand::Rng;

#[inline(always)]
pub fn run_game<const HEIGHT: usize, const WIDTH: usize, const GENERATIONS: u32>(
    height_buf: &[u8],
) {
    let size = WIDTH * HEIGHT;

    const CLEAR_PRE: &[u8] = b"\x1b[";
    const CLEAR_SUF: &[u8] = b"A";

    let clear_len = CLEAR_PRE.len() + height_buf.len() + CLEAR_SUF.len();

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
        buf.extend_from_slice_unchecked(CLEAR_PRE);
        buf.extend_from_slice_unchecked(height_buf);
        buf.extend_from_slice_unchecked(CLEAR_SUF);
        buf
    };

    let mut screen = Screen::<WIDTH, HEIGHT>::new();
    let mut stdout = io::stdout().lock();

    for _ in 0..GENERATIONS {
        screen.next_gen(&mut buf);
        let _ = stdout.write_all(&buf);
        let _ = stdout.flush();
        unsafe {
            buf.set_len(clear_len);
        }
    }
}

#[non_exhaustive]
struct Screen<const WIDTH: usize, const HEIGHT: usize> {
    cells: Box<[bool]>,
    swap: Box<[bool]>,
}

impl<const WIDTH: usize, const HEIGHT: usize> Screen<WIDTH, HEIGHT> {
    #[inline(always)]
    fn new() -> Self {
        let size = (WIDTH + 2) * (HEIGHT + 2);
        let mut rng = rand::thread_rng();
        let mut cells: Box<[bool]> = (0..size).map(|_| rng.gen()).collect();

        for col in 0..WIDTH + 2 {
            unsafe {
                // Set top row to false
                *cells.get_unchecked_mut(col) = false;
                // Set bottom row to false
                *cells.get_unchecked_mut(col + size - (WIDTH + 2)) = false;
            }
        }

        for row in 1..HEIGHT + 1 {
            unsafe {
                // Set left-most column to false
                *cells.get_unchecked_mut(row * (WIDTH + 2)) = false;
                // Set right-most column to false
                *cells.get_unchecked_mut(row * (WIDTH + 2) + WIDTH + 1) = false;
            }
        }

        let cells2 = cells.clone();
        Self {
            cells,
            swap: cells2,
        }
    }

    #[inline(always)]
    unsafe fn get_cell_unchecked(&self, row: usize, col: usize) -> bool {
        *self.cells.get_unchecked(row * (WIDTH + 2) + col)
    }

    #[inline(always)]
    fn next_gen(&mut self, buf: &mut Vec<u8>) {
        self.draw(buf);

        for row in 1..HEIGHT + 1 {
            for col in 1..WIDTH + 1 {
                let cell = unsafe { self.get_cell_unchecked(row, col) };
                let mut adjacent: u8 = 0;

                for drow in 0..3 {
                    for dcol in 0..3 {
                        // Ignore center cell
                        if drow == 1 && dcol == 1 {
                            continue;
                        }

                        if unsafe { self.get_cell_unchecked(row + drow - 1, col + dcol - 1) } {
                            adjacent += 1;
                        }
                    }
                }

                unsafe {
                    *self.swap.get_unchecked_mut(row * (WIDTH + 2) + col) =
                        (adjacent == 3) | (cell && adjacent == 2);
                }
            }
        }
        std::mem::swap(&mut self.cells, &mut self.swap)
    }

    #[inline(always)]
    fn write_line(buf: &mut Vec<u8>, slice: &[bool]) {
        let mut chunks = unsafe { slice.get_unchecked(1..slice.len() - 1).chunks_exact(8) };
        for chunk in &mut chunks {
            let val: u8 = chunk
                .iter()
                .map(|&b| b as u8)
                .enumerate()
                .map(|(idx, b)| b << idx)
                .sum();
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
        for line in unsafe {
            self.cells
                .get_unchecked(WIDTH + 2..(WIDTH + 2) * (HEIGHT + 1))
                .chunks_exact(WIDTH + 2)
        } {
            Self::write_line(buf, line);
        }
    }
}
