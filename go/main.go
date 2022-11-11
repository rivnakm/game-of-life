package main

import (
	"flag"
	"fmt"
	"math/rand"
	"os"
	"regexp"
	"strconv"

	"golang.org/x/term"
)

func main() {
	generations := flag.Int("generations", -1, "# of generations to run")
	size := flag.String("size", "", "Screen size [WxH]")

	flag.Parse()

	var height int
	var width int

	if *size == "" {
		width, height, _ = term.GetSize(0)
		width = width / 2
		height = height - 1
	} else {
		re, _ := regexp.Compile(`^(\d+)x(\d+)$`)

		if !re.MatchString(*size) {
			fmt.Fprintf(os.Stderr, "Error: Invalid size '%s'", *size)
			os.Exit(1)
		}

		result := re.FindStringSubmatch(*size)
		height, _ = strconv.Atoi(result[2])
		width, _ = strconv.Atoi(result[1])
	}

	run_game(height, width, *generations)
}

func run_game(height int, width int, generations int) {
	cells := make([]bool, height*width)
	for i := 0; i < height*width; i++ {
		cells[i] = rand.Float32() > 0.5
	}

	if generations == -1 {
		for true {
			draw_screen(cells, height, width)
			fmt.Printf("\x1b[%dA", height)
			next_gen(cells, height, width)
		}
	} else {
		for i := 0; i < generations; i++ {
			draw_screen(cells, height, width)
			fmt.Printf("\x1b[%dA", height)
			next_gen(cells, height, width)
		}
	}
}

func next_gen(cells []bool, height int, width int) {
	cells_copy := make([]bool, height*width)
	for i := 0; i < height*width; i++ {
		cells_copy[i] = cells[i]
	}

	for i := 0; i < height; i++ {
		for j := 0; j < width; j++ {
			cell := get_cell(cells_copy, i, j, height, width)
			adjacent := 0

			for n := -1; n <= 1; n++ {
				for m := -1; m <= 1; m++ {
					if (n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0) {
						continue
					}
					adjacent += int(btou(get_cell(cells_copy, i+n, j+m, height, width)))
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

			cells[i*width+j] = cell
		}
	}
}

func get_cell(cells []bool, row int, col int, height int, width int) bool {
	if row >= 0 && col >= 0 && row < height && col < width {
		return cells[(row*width)+col]
	} else {
		return false
	}
}

func draw_screen(cells []bool, height int, width int) {
	for i := 0; i < height; i++ {
		for j := 0; j < width; j++ {
			if cells[(i * width) + j] {
				fmt.Print("██");
			} else {
				fmt.Print("  ");
			}
		}
		fmt.Println("")
	}
}

func btou(b bool) uint8 {
	if b {
		return 1
	}
	return 0
}
