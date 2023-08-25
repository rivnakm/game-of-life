module main

import game { run_game }

fn main() {
	height := 50
	width := 100
	generations := 500

	run_game(height, width, generations)
}
