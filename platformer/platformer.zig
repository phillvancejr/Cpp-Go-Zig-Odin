//raylib
const std = @import("std");
const print = std.debug.print;
const c = @cImport({
    @cInclude("raylib.h");
    @cInclude("stb_image.h");
});
const is_float = std.meta.trait.isFloat;
const is_int = std.meta.trait.isIntegral;
const math = std.math;

// casting helpers
fn usize_(num: anytype) usize {
    return switch (@TypeOf(num)) {
        i32, i64, comptime_int => @intCast(usize,num),
        else => 0,
    };
}

fn i32_(num: anytype) i32 {
    const T = @TypeOf(num);
    return if (comptime is_float(T))
        @floatToInt(i32, num)
    else if ( comptime is_int(T))
        @intCast(i32, num);
}

fn f32_(num: anytype) f32 {
    const T = @TypeOf(num);
    return if ( comptime is_float(T))
        @floatCast(f32, num)
    else if ( comptime is_int(T) )
        @intToFloat(f32, num)
    else 0;
}

const scale     =   4;
const width     = 256;
const height    = 240;
const title     = "OLC Tile Based Platformer - Zig";
const tsz       = 16;

const levw      = 64;
const levh      = 16;

const CYAN = c.Color{ .r=0, .g=255, .b=255, .a=255 };

var camx : f32 = 0.0;
var camy : f32 = 0.0;

var px : f32 = 0.0;
var py : f32 = 0.0;

var pvx : f32 = 0.0;
var pvy : f32 = 0.0;
var grounded = false;
var moving = false;
var bounce = false;

// sprites
const background_raw = @embedFile("sprites/tilesx4.png");
const mario_raw = @embedFile("sprites/charactersx4.gif");
var background: c.Texture = undefined;
var mario: c.Texture = undefined;
const bts = 16;
// background sprites
const ground =   c.Rectangle{ .x=0,              .y=bts * scale,    .width=bts * scale, .height=bts * scale};
const coin =     c.Rectangle{ .x=24 * 4 * bts,   .y=bts * scale,    .width=bts * scale, .height=bts * scale};
const question = c.Rectangle{ .x=24 * 4 * bts,   .y=0 ,             .width=bts * scale, .height=bts * scale};
const brick =    c.Rectangle{ .x=22 * 4 * bts,   .y=0 ,             .width=bts * scale, .height=bts * scale};
// mario sprites - spritesheet is poorly designed with inconsistent offsets
const marior  = c.Rectangle{ .x=((17 * 16)+2) * scale, .y=((3 * 15)-1) * scale , .width=bts * scale, .height=bts * scale};
const mariol  = c.Rectangle{ .x=((14 * 16)-1) * scale, .y=((3 * 15)-1) * scale , .width=bts * scale, .height=bts * scale};
const mariojr = c.Rectangle{ .x=((22 * 16)+3) * scale, .y=((3 * 15)-1) * scale , .width=bts * scale, .height=bts * scale};
const mariojl = c.Rectangle{ .x=(( 9 * 16)-2) * scale, .y=((3 * 15)-1) * scale , .width=bts * scale, .height=bts * scale};
var mariospr = mariojr;

// facing direction
const Dir = enum {
    left,
    right
};

var last_dir = Dir.right;

fn draw_sprite(tilemap: c.Texture, sprite: c.Rectangle, x: f32, y: f32) void {
    c.DrawTextureRec(tilemap, sprite, c.Vector2{.x=x, .y=y}, c.WHITE);
}

var level : [levw*levh]u8  = undefined;

fn user_create() !void {
    // load level
    std.mem.copy(u8, level[0..],
    "................................................................"++
    "..........................@@@B?B@@@@@@@........................."++
    "..........................@@@@@@@@@@@@@........................."++
    ".......@@.................@@@@@@@@.............................."++
    ".......@@.............############........@.@..................."++
    ".......BB?B..........###..................#.#.@@@@@@@..........."++
    "...................###....................#.#.@@@@@@@..........."++
    "..................####........................@@@@@@@..........."++
    "#######################################.################.....###"++
    "......................................#.#.................###..."++
    "........................###############.#..............###......"++
    "........................#@@@@@@@@@@@@@@@#...........###........."++
    "........................#@###############........###............"++
    "........................#@@@@@@@@@@@@@@@@@@@@@###..............."++
    "........................######################.................."++
    "................................................................");

    // load sprites from embedded using stbi
    var bckimg : c.Image = undefined;
    bckimg.mipmaps = 1;
    bckimg.format = c.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8;

    var chan: i32 = undefined;

    bckimg.data = c.stbi_load_from_memory(&background_raw[0], background_raw.len, &bckimg.width, &bckimg.height, &chan, 0);

    background = c.LoadTextureFromImage(bckimg);
    c.UnloadImage(bckimg);

    // I don't know what these are for but load_gif_from_memory needs them
    var z: i32 = undefined;
    var delays: [*c]i32 = undefined;

    var mimg : c.Image = undefined;
    mimg.mipmaps = 1;
    mimg.format = c.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8;

   mimg.data = c.stbi_load_gif_from_memory(&mario_raw[0], mario_raw.len, &delays, &mimg.width, &mimg.height, &z, &chan, 0);
   mario = c.LoadTextureFromImage(mimg);
   c.UnloadImage(mimg);

}

pub fn main() !void {
    c.InitWindow(width * scale, height * scale, title[0..]);
    defer c.CloseWindow();
    c.SetTargetFPS(60);

    try user_create();

    var last = std.time.milliTimestamp();
    while ( !c.WindowShouldClose() ) {
        c.BeginDrawing();
        defer c.EndDrawing();

        const now = std.time.milliTimestamp(); 
        const dt = f32_(now - last) / 1000.0;
        last = now;
        c.ClearBackground(c.WHITE);
        user_update(dt);
    }
}

fn user_update(dt: f32) void {
    // utility functions

    const get_tile = struct{
        fn f( x: i32, y: i32) u8 {
            return if ( x >= 0 and x < levw and y >= 0 and y < levh ) 
                level[ usize_(y * levw + x) ]
            else ' ';
        }
    }.f;

    const set_tile = struct{
        fn f( x: i32, y: i32, ch: u8 ) void {
            if ( x >= 0 and x < levw and y >= 0 and y < levh ) 
                level[ usize_(y * levw + x) ] = ch;
        }
    }.f;

    _=set_tile;
    // input


    // pvx = 0.0;
    // pvy = 0.0;
    moving = false;
    if (c.IsKeyDown(c.KEY_UP))       pvy = -6.0;
    if (c.IsKeyDown(c.KEY_DOWN))     pvy =  6.0;
    if (c.IsKeyDown(c.KEY_LEFT)) {
        pvx = -6.0;
        mariospr = if (grounded) mariol else mariojl;
        last_dir = .left;
        moving = true;
    }
    if (c.IsKeyDown(c.KEY_RIGHT)) {
        pvx =  6.0;
        mariospr = if (grounded) marior else mariojr;
        last_dir = .right;
        moving = true;
    }
    if (c.IsKeyPressed(c.KEY_SPACE)) {
        if ( pvy == 0 ) pvy = -12;
        grounded = false;
        // set sprite
        mariospr = if( last_dir == .left ) mariojl else mariojr;
    }
    // gravity
    pvy += 20 * dt;
    if (grounded) {
        // slow down x movement
        // if left/right is not pressed slow down faster
        const speed: f32 = if (moving) -3 else -7;
        pvx += speed * pvx * dt;
        // stop gradually
        if (math.fabs(pvx) < 0.01 ) pvx = 0;
    }

    pvx = std.math.clamp(pvx, -10.0, 10.0);
    pvy = std.math.clamp(pvy, -100.0, 100.0);

    var newpx = px + pvx * dt;
    var newpy = py + pvy * dt;


    
    // collision
    // helpers to avoid repeated casting
    const inewpx  = i32_(newpx);
    const inewpy  = i32_(newpy);
    const ipy     = i32_(py);
    const shiftpy = i32_(py + 0.9);
    const shiftpx = i32_(px + 0.9);
    // consume coin
    var tile = get_tile(inewpx, inewpy);

    if ( tile == '@' or tile == '?' or tile == 'B') {
        set_tile(inewpx, inewpy    , '.');
        if ( tile == '?' or tile == 'B' )
            bounce = true;
    } 
    if ( get_tile(inewpx, inewpy + 1) == '@') set_tile(inewpx, inewpy + 1, '.');

    tile = get_tile(inewpx + 1, inewpy);
    if ( tile == '@' or tile == '?' or tile == 'B') {
        set_tile(inewpx + 1, inewpy, '.');
        if ( tile == '?' or tile == 'B' )
            bounce = true;
    }
    if ( get_tile(inewpx + 1, inewpy + 1) == '@') set_tile(inewpx + 1, inewpy + 1, '.');

    if ( bounce ) {
        bounce = false;
        if ( pvy < 0)
            pvy *= -1;
    }

     // moving left
    if ( pvx <= 0 ) {
        // check left upper and lower points
       if ( get_tile( inewpx, ipy) != '.' or get_tile(inewpx, shiftpy) != '.' ) {
           newpx = @floor(newpx + 1);
           pvx = 0;
       }
    // moving right
    } else {
        // check right upper and lower points
        if ( get_tile( inewpx + 1, ipy) != '.' or get_tile(inewpx + 1, shiftpy) != '.') {
            newpx = @floor(newpx);
            pvx = 0;
        }
    }
    // moving up 
    if ( pvy <= 0 ) {
        // check upper left and right points
       if ( get_tile( inewpx, inewpy) != '.' or get_tile(shiftpx, inewpy) != '.' ) {
           newpy = @floor(newpy + 1);
           pvy = 0;
       }
    // moving down
    } else {
        // check lower left and right points
        if ( get_tile( inewpx, inewpy + 1) != '.' or get_tile( shiftpx, inewpy + 1) != '.') {
            newpy = @floor(newpy);
            pvy = 0;
            grounded = true;
            mariospr = if (last_dir == .left) mariol else marior;
            bounce = false;
        }
    }

    px = newpx;
    py = newpy;

    camx = px;
    camy = py;

    // draw level
    const vis_tx = width / tsz;
    const vis_ty = height / tsz;

    // top leftmost visible tile
    var offset_x = camx - f32_(vis_tx) / 2.0;
    var offset_y = camy - f32_(vis_ty) / 2.0;

    // clamp camera
    offset_x = std.math.clamp(offset_x, 0, f32_(levw - vis_tx));
    offset_y = std.math.clamp(offset_y, 0, f32_(levh - vis_ty));

    // smooth movement
    const tile_offx = (offset_x - @floor(offset_x)) * f32_(tsz);
    const tile_offy = (offset_y - @floor(offset_y)) * f32_(tsz);

    c.ClearBackground(CYAN);
    // draw visibel tile map
    var y: i32 = 0;
    while ( y <= vis_ty  ) : ( y += 1 ) {
        var x: i32 = 0;
        while ( x <= vis_tx  ) : ( x += 1 ) {
            const xpos = (f32_( x * tsz ) - tile_offx) * f32_(scale);
            const ypos = (f32_( y * tsz ) - tile_offy) * f32_(scale);

            switch ( get_tile(x + i32_(offset_x), y + i32_(offset_y)) ) {
                '#' => draw_sprite( background, ground, xpos, ypos),
                'B' => draw_sprite( background, brick, xpos, ypos),
                '?' => draw_sprite( background, question, xpos, ypos),
                '@' => draw_sprite( background, coin, xpos, ypos),
                else =>{},
            }

        }
    }

    const xpos = ((px - offset_x) * f32_(tsz)) * f32_(scale);
    const ypos = ((py - offset_y) * f32_(tsz)) * f32_(scale);

    //const sz = tsz * scale;
    // c.DrawRectangle(xpos, ypos, sz, sz, c.GREEN);
    draw_sprite(mario, mariospr, xpos, ypos);
}
