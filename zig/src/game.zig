const std = @import("std");

const Board = struct {
    cells: []bool,
    height: usize,
    width: usize,
};

pub fn run(height: usize, width: usize, generations: u32) !void {
    const size = height * width;

    var cells = try std.heap.page_allocator.alloc(bool, size);
    defer std.heap.page_allocator.free(cells);

    var rand = std.rand.DefaultPrng.init(0);
    var i: usize = 0;
    while (i < size) : (i += 1) {
        var cell = rand.random().boolean();
        cells[i] = cell;
    }

    var board = Board {
        .cells = cells,
        .height = height,
        .width = width,
    };

    var writer = std.io.getStdOut().writer();

    i = 0;
    while (i < generations) : (i += 1) {
        try draw_screen(writer, &board);
        try writer.print("\x1b[{}A", .{board.height});
        try next_gen(&board);
    }
}

fn next_gen(board: *Board) !void {
    var cells_copy = try std.heap.page_allocator.alloc(bool, board.height * board.width);
    defer std.heap.page_allocator.free(cells_copy);

    var c: usize = 0;
    while (c < board.height * board.width) : (c += 1) {
        cells_copy[c] = board.cells[c];
    }

    var board_copy = Board{
        .cells = cells_copy,
        .height = board.height,
        .width = board.width
    };

    var i: usize = 0;
    while (i < board.height) : (i += 1) {
        var j: usize = 0;
        while (j < board.width) : (j += 1) {
            var cell = get_cell(&board_copy, i, j);
            var adjacent: u8 = 0;

            var n: usize = 0;
            while (n <= 2) : (n += 1) {
                var m: usize = 0;
                while (m <= 2) : (m += 1) {
                    if ((n == 0 and i == 0) or (m == 0 and j == 0) or (n == 1 and m == 1)) {
                        continue;
                    }
                    if (get_cell(&board_copy, i + n - 1, j + m - 1)) {
                        adjacent += 1;
                    }
                }
            }
            
            if (cell) {
                if (adjacent < 2) {
                    cell = false;
                }
                if (adjacent > 3) {
                    cell = false;
                }
            }
            else {
                if (adjacent == 3) {
                    cell = true;
                }
            }

            board.cells[(i * board.width) + j] = cell;
        }
    }
}

fn get_cell(board: *Board, row: usize, col: usize) bool {
    if (row < board.height and col < board.width) {
        return board.cells[(row * board.width) + col];
    } else {
        return false;
    }
}

fn draw_screen(writer: anytype, board: *Board) !void {
    var i: usize = 0;
    while (i < board.height) : (i += 1) {
        var j: usize = 0;
        while (j < board.width) : (j += 1) {
            if (board.cells[(i * board.width) + j]) {
                try writer.print("██", .{});
            }
            else {
                try writer.print("  ", .{});
            }
        }
        try writer.print("\n", .{});
    }
}