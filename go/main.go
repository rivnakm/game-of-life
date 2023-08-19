package main

import (
	"bufio"
	"fmt"
	"io"
	"math/rand"
	"os"
)

func main() {
	generations := 500
	height := 50
	width := 100

	run_game(height, width, generations)
}

type Board struct {
	cells  []bool
	swap   []bool
	height int
	width  int
}

func run_game(height int, width int, generations int) {
	board := Board{cells: make([]bool, height*width), swap: make([]bool, height*width), height: height, width: width}
	for i := 0; i < height*width; i++ {
		board.cells[i] = rand.Float32() > 0.5
	}

	clear := fmt.Sprintf("\x1b[%dA", board.height)
	writer := bufio.NewWriterSize(os.Stdout,
		// All cells
		height*width*6+
			// Newlines
			height+
			// Reset
			len(clear),
	)

	for i := 0; i < generations; i++ {
		writer.WriteString(clear)
		draw_screen(writer, &board)
		writer.Flush()
		next_gen(&board)
	}
}

func next_gen(board *Board) {
	for i := 0; i < board.height; i++ {
		for j := 0; j < board.width; j++ {
			cell := get_cell(board, i, j)
			adjacent := 0

			for n := -1; n <= 1; n++ {
				for m := -1; m <= 1; m++ {
					if n == 0 && m == 0 {
						continue
					}
					if get_cell(board, i+n, j+m) {
						adjacent++
					}
				}
			}

			board.swap[i*board.width+j] = adjacent == 3 || (cell && adjacent == 2)
		}
	}
	board.cells, board.swap = board.swap, board.cells
}

func get_cell(board *Board, row int, col int) bool {
	return row >= 0 && col >= 0 && row < board.height && col < board.width && board.cells[row*board.width+col]
}

func draw_screen(writer io.Writer, board *Board) {
	for i := 0; i < board.height; i++ {
		for j := 0; j < board.width; j++ {
			if board.cells[(i*board.width)+j] {
				writer.Write([]byte("██"))
			} else {
				writer.Write([]byte("  "))
			}
		}
		writer.Write([]byte("\n"))
	}
}
