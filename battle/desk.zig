const std = @import("std");
const _print = std.debug.print;

pub fn print(msg: []const u8) void {
    _print("{s}", .{msg});
}

pub fn get_seed() u64 {
    return @bitCast(u64,std.time.milliTimestamp());
}