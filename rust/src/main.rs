mod constant;
mod game;
mod trait_ext;

fn main() {
    const GENERATIONS: u32 = 500;
    const HEIGHT: usize = 50;
    const WIDTH: usize = 100;

    game::run_game::<HEIGHT, WIDTH, GENERATIONS>();
}
