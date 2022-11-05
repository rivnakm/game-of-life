use clap::Parser;
use regex::Regex;

mod game;

/// Conway's Game of Life
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Screen size [WxH]
    #[arg(short, long)]
    size: Option<String>,

    /// Number of iterations to run
    #[arg(short, long)]
    iterations: Option<u32>,
}

fn main() {
    let args = Args::parse();

    let (width, height) = match args.size {
        None => {
            let (width, height) = term_size::dimensions().expect("Unable to get terminal size");
            (width / 2, height - 1)
        }
        Some(size) => {
            let re = Regex::new(r"^(\d+)x(\d+)$").unwrap();
            let captures = re
                .captures(size.as_str())
                .expect(format!("Invalid size '{}'", size).as_str());
            let width: usize = captures.get(1).unwrap().as_str().parse().unwrap();
            let height: usize = captures.get(2).unwrap().as_str().parse().unwrap();
            (width, height)
        }
    };

    game::run_game(height, width, args.iterations);
}
