const std = @import("std");
const io = std.io;

const game = @import("game.zig");

const generations = 100;
const height = 50;
const width = 100;
pub fn main() !void {
   try game.run(height, width, generations);
}
