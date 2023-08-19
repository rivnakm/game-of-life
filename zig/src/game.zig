const std = @import("std");
const Allocator = std.mem.Allocator;

const Board = struct {
    cells: []bool,
    height: usize,
    width: usize,
};

pub fn run(height: usize, width: usize, generations: u32) !void {
    const size = height * width;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    const allocator = arena.allocator();
    defer arena.deinit();
    var cells = try allocator.alloc(bool, size);

    var rand = std.rand.DefaultPrng.init(0);
    const random = rand.random();
    for (0..size) |i| {
        const cell = random.boolean();
        cells[i] = cell;
    }

    var board = Board {
        .cells = cells,
        .height = height,
        .width = width,
    };

    var writer = std.io.getStdOut().writer();
    for (0..generations) |_| {
        try draw_screen(writer, &board);
        try writer.print("\x1b[{}A", .{board.height});
        try next_gen(allocator, &board);
    }
}

fn next_gen(allocator: Allocator, board: *Board) !void {
    var cells_copy = try allocator.alloc(bool, board.height * board.width);
    @memcpy(cells_copy, board.cells);

    for (0..board.height * board.width) |c| {
        cells_copy[c] = board.cells[c];
    }

    var board_copy = Board{
        .cells = cells_copy,
        .height = board.height,
        .width = board.width
    };

    for (0..board.height) |i| {
        for (0..board.width) |j| {
            var cell = get_cell(&board_copy, i, j);
            var adjacent: u8 = 0;

            for (0..3) |n| {
                for (0..3) |m| {
                    if ((n == 0 and i == 0) or (m == 0 and j == 0) or (n == 1 and m == 1)) {
                        continue;
                    }
                    if (get_cell(&board_copy, i + n - 1, j + m - 1)) {
                        adjacent += 1;
                    }
                }
            }
            
            if (cell) {
                switch (adjacent) {
                    2, 3 => cell = true,
                    else => cell = false
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
    for (0..board.height) |i| {
        for (0..board.width) |j| {
            if (board.cells[(i * board.width) + j]) {
                try writer.writeAll("██");
            }
            else {
                try writer.writeAll("  ");
            }
        }
        try writer.writeByte('\n');
    }
}
