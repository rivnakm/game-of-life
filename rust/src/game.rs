use std::io::{self, Write};

use rand::Rng;

pub fn run_game<const HEIGHT: usize, const WIDTH: usize, const GENERATIONS: u32>() {
    let mut screen = Screen::<WIDTH, HEIGHT>::new();

    let size = WIDTH * HEIGHT;

    let mut stdout = io::stdout().lock();

    let mut buf = format!("\x1b[{}A", HEIGHT + 1).into_bytes();
    let clear_len = buf.len();
    buf.reserve(
        // Space for all cells
        size * 6
        // Space for newlines
        + HEIGHT, // Bytes for the clear sequence
    );

    for _ in 0..GENERATIONS {
        screen.draw(&mut buf);
        screen.next_gen();
        let _ = stdout.write_all(&buf).and_then(|_| stdout.flush());
        unsafe {
            buf.set_len(clear_len);
        }
    }
}

#[non_exhaustive]
struct Screen<const WIDTH: usize, const HEIGHT: usize> {
    cells: Box<[bool]>,
    cells2: Box<[bool]>,
}

use crate::{constant::LOOKUP, trait_ext::UncheckedVecExt};
impl<const WIDTH: usize, const HEIGHT: usize> Screen<WIDTH, HEIGHT> {
    fn new() -> Self {
        let size = WIDTH * HEIGHT;
        let mut rng = rand::thread_rng();
        let cells: Box<[bool]> = (0..size).map(|_| rng.gen()).collect();

        let cells2 = cells.clone();
        Self { cells, cells2 }
    }

    #[inline(always)]
    unsafe fn get_cell_unchecked(&self, row: usize, col: usize) -> bool {
        unsafe { *self.cells.get_unchecked(row * WIDTH + col) }
    }

    fn next_gen(&mut self) {
        for row in 0..HEIGHT {
            for col in 0..WIDTH {
                let cell = unsafe { self.get_cell_unchecked(row, col) };
                let mut adjacent: u8 = 0;

                for drow in 0..3 {
                    for dcol in 0..3 {
                        // Ignore center cell and OOB
                        if (drow == 0 && row == 0)
                            | (dcol == 0 && col == 0)
                            | (row == HEIGHT && drow == 3)
                            | (col == WIDTH && dcol == 3)
                            || (drow == 1 && dcol == 1)
                        {
                            continue;
                        }

                        if unsafe { self.get_cell_unchecked(row + drow - 1, col + dcol - 1) } {
                            adjacent += 1;
                        }
                    }
                }

                unsafe {
                    *self.cells2.get_unchecked_mut(row * WIDTH + col) =
                        (adjacent == 3) | (cell && adjacent == 2);
                }
            }
        }
        std::mem::swap(&mut self.cells, &mut self.cells2)
    }

    #[inline(always)]
    fn write_line(writer: &mut Vec<u8>, slice: &[bool]) {
        const REM_LUT: [&[u8]; 2] = [b"  ", b"\xE2\x96\x88\xE2\x96\x88"];

        let mut chunks = slice.chunks_exact(8);
        for chunk in &mut chunks {
            let val: u8 = chunk
                .iter()
                .map(|&b| b as u8)
                .enumerate()
                .map(|(idx, b)| b << idx)
                .sum();
            unsafe {
                let pattern = LOOKUP.get_unchecked(val as usize);
                writer.extend_from_slice_unchecked(pattern);
            }
        }

        for &cell in chunks.remainder() {
            unsafe {
                writer.extend_from_slice_unchecked(REM_LUT[cell as usize]);
            }
        }
    }

    #[inline]
    fn draw(&self, writer: &mut Vec<u8>) {
        for line in self.cells.chunks_exact(WIDTH) {
            Self::write_line(writer, line);
            unsafe {
                writer.push_unchecked(b'\n');
            }
        }
    }
}
