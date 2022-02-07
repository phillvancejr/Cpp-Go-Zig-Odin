const std = @import("std");
const print = std.debug.print;

const width = 20;
const height = width;
const max_iterations = 10_000;
// up to 0 - 1000 iterations per second
// you can increase iterations to speed up the simulation and see more patterns
// but increasing it too much makes rendering look bad because the ansi functions can't keep up
const iterations_per_second = 10;

var board = [_]Color{.white} ** ( width * height );
var ant_x: i32 = width/2;
var ant_y: i32 = height/2;
var ant_dir: i32 = up;
var current_move: i32 = 0;

const Color = enum {
    white,
    black,
};

const left = 0;
const up = 1;
const right = 2;
const down = 3;

pub fn main() void {
    drawBoard();
    while ( true ) {
        const pos = @intCast(usize, ant_y * width + ant_x);

        if ( board[pos] == .white ) {
            turnRight(&ant_dir);
            board[pos] = .black;
            move(&ant_x, &ant_y, ant_dir);
        } else {
            turnLeft(&ant_dir);
            board[pos] = .white;
            move(&ant_x, &ant_y, ant_dir);
        }

        wrap(&ant_x);
        wrap(&ant_x);
        drawBoard();
    }
}

fn turnRight(dir: *i32) void {
    dir.* = if ( dir.* == down ) left else dir.*+1;
}

fn turnLeft(dir: *i32) void {
    dir.* = if ( dir.* == left ) down else dir.*-1;
}

fn move(x: *i32, y: *i32, dir: i32) void {
    switch ( dir ) {
        left => x.* -= 1,
        up => y.* -= 1,
        right => x.* += 1,
        down =>  y.* += 1,
        else => {}
    }
}

fn wrap(n: *i32) void {
    if ( n.* >= width )
        n.* = 0
    else if (n.* <= 0 )
        n.* = width - 1;
}

fn red(set: bool) void {
    if (set) print("\x1b[31m", .{})
    else print("\x1b[0m", .{});
}

fn clearScreen() void {
    print("\x1b[1J", .{});
}

fn resetCursor() void {
    print("\x1b[1;1H", .{});
}
fn drawBoard() void {
    clearScreen();
    resetCursor();
    print("\nmove: {}\n", .{current_move});
    current_move += 1;

    var y: i32 = 0;
    while ( y < height ) : ( y += 1 ) {
        var x: i32 = 0;
        while ( x < width ) : ( x += 1 ) {
            // if this is the ant
            if ( y == ant_y and x == ant_x )  {
                red(true);
                switch ( ant_dir ) {
                    left => print("<", .{}),
                    up => print("A", .{}),
                    right => print(">", .{}),
                    down => print("V", .{}),
                    else => {}
                }
                red(false);
            } else {
                if ( board[ @intCast(usize, y * width + x) ] == .white ) 
                    print(".", .{})
                else 
                    print("#", .{});
            }
        }
        print("\n", .{});
    }
    // delay
    // sleep takes nanoseconds
    std.time.sleep(1_000_000_000/iterations_per_second);
}