package main

import (
	"flag"
	"fmt"
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
	fmt.Printf("Running %dx%d game with %d generations\n", width, height, generations)
}
