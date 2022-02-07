const std = @import("std");
const print = std.debug.print;
const c = @cImport({
   // @cDefine("STB_IMAGE_WRITE_IMPLEMENTATION", "");
    @cInclude("stb/stb_image_write.h");
});

const width = 4;
const height = width;
const components = 3;

var pixels: [width*height*components]u8 = undefined;

// print to console using ansi escape
fn print_pixels(ansi: bool) void {
    var y: i32 = 0;
    while ( y < height ) : ( y += 1 ) {
        var x: i32 = 0;
        while ( x < width * components ) : ( x += components) {
            const index = @intCast(usize, y*width*components+x);
            const r = pixels[index];
            const g = pixels[index + 1];
            const b = pixels[index + 2];

            if ( ansi ) {
                // white
                var color = "\x1b[97m";
                if ( r == 0 )
                    // black/gray
                    color = "\x1b[30m";
                print("{s}\u{2588}\u{2588}\u{2588}", .{color});
            } else {
                if ( r == 255)
                    print("{}{}{}", .{r,g,b})
                else
                    print("000000000",.{});
            }
        }
        print("\x1b[0m\n",.{});
    }
}

pub fn main() !void {
        
    var y: i32 = 0;
    while ( y < height ) : ( y += 1 ) {
        var x: i32 = 0;
        while ( x < width * components ) : ( x += components) {
            const scaled_x:i32 = @divFloor(x,3);
            // if left half
            var color:u8 = 255;
            if (scaled_x < width/2) {
                // if upper quarter
                if ( y < height / 2)
                    color = 255
                else
                    color = 0;
            } 
            else { // right half
                // upper right quarter
                if ( y < height / 2)
                    color = 0
                else
                    color = 255;
            }
            const index = @intCast(usize, y*width*components+x); 
            pixels[index]     = color;
            pixels[index + 1] = color;
            pixels[index + 2] = color;
        }
    }

    const ppm = (try std.fs.cwd().createFile("ppm_png/out.ppm", .{})).writer();

    // write ppm manually

    try ppm.print("P3\n{} {}\n255\n", .{width, height});


    y  = 0;
    while ( y < height ) : ( y += 1 ) {
        var x: i32 = 0;
        while ( x < width * components ) : ( x += components) {
            const index = @intCast(usize, y*width*components+x);
            const r = pixels[index];
            const g = pixels[index + 1];
            const b = pixels[index + 2];

            try ppm.print("{} {} {}\n", .{r, g, b});
        }
    }
    // // write png with stb
    _=c.stbi_write_png("ppm_png/out.png", width, height, 3, &pixels[0], width*3);
    // print pixels to console
    print_pixels(true);

}