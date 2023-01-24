use warnings;
use strict;

use Class::Struct;

my $generations = 500;
my $height = 50;
my $width = 100;

struct Board => {
    cells   => '@',
    height  => '$',
    width   => '$',
};

sub getCell {
    my ($board, $row, $col) = @_;
    if ($row >= 0 && $col >= 0 && $row < $board->height && $col < $board->width) {
        return @{$board->cells}[($row * $board->width) + $col];
    } else {
        return 0;
    }
}

sub nextGen {
    my $boardCopy = Board->new();
    $boardCopy->height($_[0]->height);
    $boardCopy->width($_[0]->width);
    push(@{$boardCopy->cells}, @{$_[0]->cells});

    for (my $i = 0; $i < $_[0]->height; $i++) {
        for (my $j = 0; $j < $_[0]->width; $j++) {
            my $cell = getCell($boardCopy, $i, $j);
            my $adjacent = 0;

            for (my $n = -1; $n <= 1; $n++) {
                for (my $m = -1; $m <= 1; $m++) {
                    if (($n == -1 && $i == 0) || ($m == -1 && $j == 0) || ($n == 0 && $m == 0)) {
                        # skip
                    } elsif (getCell($boardCopy, $i + $n, $j + $m)) {
                        $adjacent++;
                    }
                }
            }

            if ($cell) {
                if ($adjacent < 2) {
                    $cell = 0;
                }
                if ($adjacent > 3) {
                    $cell = 0;
                }
            } else {
                if ($adjacent == 3) {
                    $cell = 1;
                }
            }

            @{$_[0]->cells}[$i * $_[0]->width + $j] = $cell;
        }
    }
}

sub drawScreen {
    my ($board) = @_;
    my @cells = @{$board->cells};
    for (my $i = 0; $i < $board->height; $i++) {
        for (my $j = 0; $j < $board->width; $j++) {
            my $cell = @cells[($i * $board->width) + $j];
            if ($cell) {
                print("██");
            } else {
                print("  ");
            }
        }
        print("\n");
    }
}

my $board = Board->new();
$board->height($height);
$board->width($width);

for (my $i = 0; $i < ($height * $width); $i++) {
    if (rand(1) > 0.5) {
        push(@{$board->cells}, 1);
    }
    else {
        push(@{$board->cells}, 0);
    }
}

for (my $i = 0; $i < $generations; $i++) {
    drawScreen($board);
    print("\033[${height}A");
    nextGen($board);
}