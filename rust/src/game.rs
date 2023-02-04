use std::io::{stdout, BufWriter, Write};

use rand::Rng;

const BECOME_ALIVE: [bool; 9] = [false, false, false, true, false, false, false, false, false];
const SURVIVE: [bool; 9] = [false, false, true, true, false, false, false, false, false];

pub fn run_game(height: usize, width: usize, generations: u32) {
    let mut screen = Screen::new(height, width);

    let stdout = stdout();
    let mut handle = stdout.lock();
    let mut writer = BufWriter::with_capacity(height * width * 2 + height * 2 + 16, handle);
    for _ in 0..generations {
        screen.draw(&mut writer);
        print!("\x1b[{}A", screen.height); // Move cursor up
        screen.next_gen();
        writer.flush();
    }
}

#[non_exhaustive]
#[derive(Debug)]
struct Screen {
    width: usize,
    height: usize,
    cells: Vec<bool>,
    cells2: Vec<bool>,
}

impl Screen {
    pub fn new(height: usize, width: usize) -> Self {
        let length = height * width;
        let mut cells: Vec<bool> = Vec::with_capacity(length);
        unsafe { cells.set_len(length) }
        let mut rng = rand::thread_rng();
        cells.fill_with(|| rng.gen());
        Self {
            width,
            height,
            cells2: cells.clone(),
            cells,
        }
    }
    fn draw<W>(&self, writer: &mut W)
    where
        W: Write,
    {
        self.cells.chunks(self.width).for_each(|arr| {
            arr.into_iter().for_each(|&alive| {
                writer.write_all(if alive {
                    b"\xE2\x96\x88\xE2\x96\x88"
                } else {
                    b"  "
                });
            });
            writer.write(b"\n");
        });
    }
    fn next_gen(&mut self) {
        for (idx, &cell) in self.cells.iter().enumerate() {
            let x = idx % self.width;
            let y = idx / self.width;
            let neighbors = self.get_neighbours(x, y) as usize;

            let new_cell = if cell {
                SURVIVE[neighbors]
            } else {
                BECOME_ALIVE[neighbors]
            };

            self.cells2[idx] = new_cell
        }
        std::mem::swap(&mut self.cells, &mut self.cells2)
    }
    #[inline(always)]
    fn get_neighbours(&self, x: usize, y: usize) -> u8 {
        let (height, width) = (self.height, self.width);
        let (xm1, xp1) = if x == 0 {
            (width - 1, x + 1)
        } else if x == width - 1 {
            (x - 1, 0)
        } else {
            (x - 1, x + 1)
        };
        let (ym1, yp1) = if y == 0 {
            (height - 1, y + 1)
        } else if y == height - 1 {
            (y - 1, 0)
        } else {
            (y - 1, y + 1)
        };
        [
            xm1 + ym1 * width,
            x + ym1 * width,
            xp1 + ym1 * width,
            xm1 + y * width,
            xp1 + y * width,
            xm1 + yp1 * width,
            x + yp1 * width,
            xp1 + yp1 * width,
        ]
        .into_iter()
        .fold(0u8, |acc, pos| acc + self.cells[pos] as u8)
    }

    fn get_cell(&self, x: usize, y: usize) -> bool {
        unsafe { *self.cells.get_unchecked(x + y * self.width) }
    }
}
