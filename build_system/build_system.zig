const print = @import("std").debug.print;

extern fn add_five(n: i32) i32;

pub fn main() void {
    print("result:{}\n", .{add_five(10)});
}