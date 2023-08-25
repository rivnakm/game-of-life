module game

import rand

struct Board {
	height int
	width int
mut:
	cells []bool
}

fn get_cell(board Board, row int, col int) bool {
	if row >= 0 && col >= 0 && row < board.height && col < board.width {
		return board.cells[row * board.width + col]
	}
	return false
}

fn next_gen(mut board Board) {
	cells_copy := board.cells.clone()
	board_copy := Board{height: board.height, width: board.width, cells: cells_copy}

	for i in 0 .. board.height {
		for j in 0 .. board.width {
			mut cell := get_cell(board_copy, i, j)
			mut adjacent := 0

			for n in -1 .. 2 {
				for m in -1 .. 2 {
					if n == 0 && m == 0 {
						continue
					}
					if get_cell(board_copy, i + n, j + m) {
						adjacent += 1
					}
				}
			}

			if cell {
				if adjacent < 2 {
					cell = false
				}
				if adjacent > 3 {
					cell = false
				}
			} else {
				if adjacent == 3 {
					cell = true
				}
			}

			board.cells[i * board.width + j] = cell
		}
	}
}

fn draw_screen(board Board) {
	for i in 0 .. board.height {
		for j in 0 .. board.width {
			if board.cells[i * board.width + j] {
				print("██")
			} else {
				print("  ")
			}
		}
		print("\n")
	}
}

pub fn run_game(height int, width int, generations int) {
	size := height * width
	mut cells := []bool{len: size, cap: size}

	for i in 0 .. size {
		cells[i] = rand.u8() % 2 == 0
	}

	mut board := Board{height: height, width: width, cells: cells}

	for _ in 0 .. generations {
		draw_screen(board)
		print("\x1b[${height}A")
		next_gen(mut board)
	}
}
