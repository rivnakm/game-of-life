use crate::byte_buffer::{ByteBuffer, USIZE_LEN};

mod byte_buffer;
mod constant;
mod game;
mod trait_ext;

fn main() {
    const GENERATIONS: u32 = 500;
    const HEIGHT: usize = 50;
    const WIDTH: usize = 100;

    const HEIGHT_BUF: &[u8] = ByteBuffer::<USIZE_LEN>::usize_to_ascii_bytes(HEIGHT).read();

    game::run_game::<HEIGHT, WIDTH, GENERATIONS>(HEIGHT_BUF);
}
