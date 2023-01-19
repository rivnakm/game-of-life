const std = @import("std");

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

    var writer = std.io.getStdOut().writer();

    i = 0;
    while (i < generations) : (i += 1) {
        try draw_screen(writer, cells, height, width);
        try writer.print("\x1b[{}A", .{height});
        try next_gen(cells, height, width);
    }
}

fn next_gen(cells: []bool, height: usize, width: usize) !void {
    var cells_copy = try std.heap.page_allocator.alloc(bool, height * width);
    defer std.heap.page_allocator.free(cells_copy);

    var c: usize = 0;
    while (c < height * width) : (c += 1) {
        cells_copy[c] = cells[c];
    }

    var i: usize = 0;
    while (i < height) : (i += 1) {
        var j: usize = 0;
        while (j < width) : (j += 1) {
            var cell = get_cell(cells_copy, i, j, height, width);
            var adjacent: u8 = 0;

            var n: usize = 0;
            while (n <= 2) : (n += 1) {
                var m: usize = 0;
                while (m <= 2) : (m += 1) {
                    if ((n == 0 and i == 0) or (m == 0 and j == 0) or (n == 1 and m == 1)) {
                        continue;
                    }
                    adjacent += if (get_cell(cells_copy, i + n - 1, j + m - 1, height, width)) 1 else 0;
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

            cells[(i * width) + j] = cell;
        }
    }
}

fn get_cell(cells: []bool, row: usize, col: usize, height: usize, width: usize) bool {
    if (row >= 0 and col >= 0 and row < height and col < width) {
        return cells[(row * width) + col];
    } else {
        return false;
    }
}

fn draw_screen(writer: anytype, cells: []bool, height: usize, width: usize) !void {
    var i: usize = 0;
    while (i < height) : (i += 1) {
        var j: usize = 0;
        while (j < width) : (j += 1) {
            if (cells[(i * width) + j]) {
                try writer.print("██", .{});
            }
            else {
                try writer.print("  ", .{});
            }
        }
        try writer.print("\n", .{});
    }
}