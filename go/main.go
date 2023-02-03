package main

import (
	"fmt"
	"math/rand"
)

func main() {
	generations := 500
	height := 50
	width := 100

	run_game(height, width, generations)
}

type Board struct {
	cells	[]bool
	height	int
	width	int
}

func run_game(height int, width int, generations int) {
	board := Board{cells: make([]bool, height*width), height: height, width: width}
	for i := 0; i < height*width; i++ {
		board.cells[i] = rand.Float32() > 0.5
	}

	for i := 0; i < generations; i++ {
		draw_screen(board)
		fmt.Printf("\x1b[%dA", board.height)
		next_gen(board)
	}
}

func next_gen(board Board) {
	board_copy := Board{cells: make([]bool, board.height*board.width), height: board.height, width: board.width}
	for i := 0; i < board.height*board.width; i++ {
		board_copy.cells[i] = board.cells[i]
	}

	for i := 0; i < board.height; i++ {
		for j := 0; j < board.width; j++ {
			cell := get_cell(board_copy, i, j)
			adjacent := 0

			for n := -1; n <= 1; n++ {
				for m := -1; m <= 1; m++ {
					if (n == 0 && m == 0) {
						continue
					}
					if(get_cell(board_copy, i+n, j+m)) {
						adjacent++
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

			board.cells[i*board.width+j] = cell
		}
	}
}

func get_cell(board Board, row int, col int) bool {
	if row >= 0 && col >= 0 && row < board.height && col < board.width {
		return board.cells[(row*board.width)+col]
	} else {
		return false
	}
}

func draw_screen(board Board) {
	for i := 0; i < board.height; i++ {
		for j := 0; j < board.width; j++ {
			if board.cells[(i * board.width) + j] {
				fmt.Print("██");
			} else {
				fmt.Print("  ");
			}
		}
		fmt.Println("")
	}
}
