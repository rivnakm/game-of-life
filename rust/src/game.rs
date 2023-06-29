use std::io::{self, BufWriter, Write};
use rand::{rngs::SmallRng, Rng, SeedableRng};

#[inline(always)]
const fn num_length(num: usize) -> usize {
    if num < 10 {
        return 1;
    }
    if num < 100 {
        return 2;
    }
    if num < 1_000 {
        return 3;
    }
    if num < 10_000 {
        return 4;
    }
    if num < 100_000 {
        return 5;
    }
    if num < 1_000_000 {
        return 6;
    }
    if num < 10_000_000 {
        return 7;
    }
    if num < 100_000_000 {
        return 8;
    }
    if num < 1_000_000_000 {
        return 9;
    }

    #[cfg(target_pointer_width = "32")]
    #[inline(always)]
    const fn inner(num: usize) -> usize {
        10
    }

    #[cfg(target_pointer_width = "64")]
    #[inline(always)]
    const fn inner(num: usize) -> usize {
        if num < 10_000_000_000 {
            return 10;
        }
        if num < 100_000_000_000 {
            return 11;
        }
        12
    }

    inner(num)
}

pub fn run_game(height: usize, width: usize, generations: u32) {
    let mut screen = Screen::new(width, height);

    let size = width * height;

    let height_len = num_length(height);

    let stdout = io::stdout().lock();
    let mut writer = BufWriter::with_capacity(size * 6 + height + 3 + height_len, stdout);

    let clear = format!("\x1b[{}A", screen.height);
    let clear = clear.as_bytes();

    // screen.draw(&mut writer);

    for _ in 0..generations {
        screen.next_gen();
        let _ = writer.write_all(clear);
        screen.draw(&mut writer);
    }
    std::mem::swap(&mut screen.cells, &mut screen.cells2)
}

#[non_exhaustive]
struct Screen {
    height: usize,
    width: usize,
    cells: Vec<bool>,
    cells2: Vec<bool>,
}

use crate::constant::LOOKUP;
impl Screen {
    fn new(width: usize, height: usize) -> Self {
        let size = width * height;
        let mut rng = SmallRng::from_entropy();
        let cells: Vec<bool> = (0..size).map(|_| rng.gen()).collect();

        let cells2 = cells.clone();
        Self {
            width,
            height,
            cells,
            cells2,
        }
        Ok(())
    }

    #[allow(clippy::manual_range_contains)]
    fn next_gen(&mut self) {
        for i in 0..self.height {
            for j in 0..self.width {
                let cell = self.get_cell(i, j);
                let mut adjacent: u8 = 0;

                for n in 0..3 {
                    for m in 0..3 {
                        // avoid unsigned int overflow and ignore center cell
                        if (n == 0 && i == 0) | (m == 0 && j == 0) || (n == 1 && m == 1) {
                            continue;
                        }

                        if self.get_cell(i + n - 1, j + m - 1) {
                            adjacent += 1;
                        }
                    }
                }

                let x = unsafe { self.cells2.get_unchecked_mut(i * self.width + j) };
                *x = (adjacent == 3) | (cell && adjacent == 2);
            }
        }
        std::mem::swap(&mut self.cells, &mut self.cells2)
    }

    #[inline(always)]
    fn write_line<W: Write>(mut writer: W, slice: &[bool]) -> io::Result<()> {
        let mut chunks = slice.chunks_exact(8);
        while let Some(chunk) = chunks.next() {
            let val: u8 = chunk
                .into_iter()
                .enumerate()
                .map(|(idx, &b)| (b as u8) << idx)
                .sum();
            let pattern = LOOKUP[val as usize];
            writer.write_all(pattern)?;
        }
        for &cell in chunks.remainder() {
            writer.write_all(
                [b"  ".as_slice(), b"\xE2\x96\x88\xE2\x96\x88".as_slice()][cell as usize],
            )?;
        }
        Ok(())
    }
    #[inline(always)]
    fn get_cell(&self, row: usize, col: usize) -> bool {
        (row < self.height) & (col < self.width)
            && unsafe { *self.cells.get_unchecked(row * self.width + col) }
    }
    #[inline]
    fn draw<W: Write>(&self, mut writer: W) {
        for line in self.cells.chunks_exact(self.width) {
            let _ = Self::write_line(&mut writer, line);
            let _ = writer.write_all(b"\n");
        }
        // for i in 0..self.height {
        //     for j in 0..self.width {
        //         let _ = writer.write_all(
        //             if unsafe { *self.cells.get_unchecked(i * self.width + j) } {
        //                 b"\xE2\x96\x88\xE2\x96\x88"
        //             } else {
        //                 b"  "
        //             },
        //         );
        //     }
        //     let _ = writer.write_all(b"\n");
        // }
        let _ = writer.flush();
    }
}
