#!/usr/bin/php -q
<?php

class Board {
    public $height;
    public $width;
    public $cells;

    public function __construct($height, $width, $cells) {
        $this->height = $height;
        $this->width = $width;

        if ($cells == null) {
            for ($i = 0; $i < $height * $width; $i++) {
                $this->cells[] = (bool) rand(0, 1);
            }

        } else {
            $this->cells = $cells;
        }
    }

    public function copy() {
        return new Board($this->height, $this->width, $this->cells);
    }

    public function draw() {
        for ($i = 0; $i < $this->height; $i++) {
            for ($j = 0; $j < $this->width; $j++) {
                if ($this->cells[($i * $this->width) + $j]) {
                    echo "██";
                } else {
                    echo "  ";
                }
            }
            echo "\n";
        }
    }

    public function get_cell($row, $col) {
        if (0 <= $row && $row < $this->height && 0 <= $col && $col < $this->width) {
            return $this->cells[($row * $this->width) + $col];
        } else {
            return false;
        }
    }
}

function next_generation($board) {
    $board_copy = $board->copy();

    for ($i = 0; $i < $board->height; $i++) {
        for ($j = 0; $j < $board->width; $j++) {
            $cell = $board_copy->get_cell($i, $j);
            $adjacent = 0;

            for ($n = -1; $n <= 1; $n++) {
                for ($m = -1; $m <= 1; $m++) {
                    if ($n == 0 && $m ==0) {
                        continue;
                    }
                    if ($board_copy->get_cell($i+$n, $j+$m)) {
                        $adjacent++;
                    }
                }
            }

            if ($cell) {
                if ($adjacent < 2) {
                    $cell = false;
                }
                if ($adjacent > 3) {
                    $cell = false;
                }
            } else {
                if ($adjacent == 3) {
                    $cell = true;
                }
            }

            $board->cells[($i * $board->width) + $j] = $cell;
        }
    }
}

function run_game($height, $width, $generations) {
    $board = new Board($height, $width, null);

    for ($i = 0; $i < $generations; $i++) {
        $board->draw();
        echo "\033[".$height."A";
        next_generation($board);
    }
}

$generations = 500;
$height = 50;
$width = 100;

run_game($height, $width, $generations);

?>