const std = @import("std");
const print = std.debug.print;
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    var seed = @bitCast(u64, std.time.milliTimestamp());
    var number = @intCast(i32, std.rand.DefaultPrng.init(seed).random().intRangeAtMost(u32, 1, 5));

    var guesses: i32 = 1;

    print("guess 1-5: ", .{});
    var guess = try readNum(); 

    while ( guess != number ) : ( guess = try readNum() ) {
        if ( guess < number )
            print("guess higher!\n", .{})
        else
            print("guess lower!\n", .{});
        guesses += 1;
    }

    print("you got it in {} tries\n", .{guesses});
}

// if there is an error reading the input set it to -1
fn readNum() !i32 {
    var buf: [10]u8 = undefined;
    if ( stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch return @intCast(i32,-1) ) | input |  {
        var num = input;

        if ( !std.ascii.isDigit(num[0])) std.mem.copy(u8, num, "-1");

        return std.fmt.parseInt(i32, num , 10);

    } else return @intCast(i32, -1);
}
