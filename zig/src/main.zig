const std = @import("std");
const io = std.io;

const game = @import("game.zig");

pub fn main() !void {
   const generations = 100;
   const height = 50;
   const width = 100;

   try game.run(height, width, generations);
}
