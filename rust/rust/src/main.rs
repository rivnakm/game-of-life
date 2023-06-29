mod constant;
mod game;

fn main() {
    let generations = 500;
    let height = 50;
    let width = 100;

    game::run_game(height, width, generations);
}
