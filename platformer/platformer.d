import core.stdc.string: memcpy;
import deps.raylib.raylib;
import deps.stb.image;

import algo = std.algorithm: 
    clamp
;
    
import math = core.stdc.math: 
    floor,
    fabs
;

enum width = 256;
enum height = 240;
enum title = "OLC Tile Based Platformer - D";
enum scale = 4;
enum CYAN = Color( 0, 255, 255, 255 );

enum levw = 64;
enum levh = 16;
enum tsz = 16;
enum visx = width / tsz;
enum visy = height / tsz;

auto camx   = 0.0;
auto camy   = 0.0;
auto px     = 0.0;
auto py     = 0.0;
auto pvx    = 0.0;
auto pvy    = 0.0;
auto grounded = false;
auto moving = false;
auto bounce = false;

// sprites
enum background_raw = cast(const stbi_uc[])import("sprites/tilesx4.png");
enum mario_raw = cast(const stbi_uc[])import("sprites/charactersx4.gif");
Texture background;
Texture mario;
enum bts = 16;
// background sprites
enum ground = Rectangle( 0, bts * scale, bts * scale, bts * scale );
enum coin = Rectangle( 24 * 4 * bts, bts * scale, bts * scale, bts * scale);
enum question = Rectangle( 24 * 4 * bts, 0 , bts * scale, bts * scale);
enum brick = Rectangle( 22 * 4 * bts, 0 , bts * scale, bts * scale);
// mario sprites - spritesheet is poorly designed with inconsistent offsets
enum marior  = Rectangle( ((17 * 16)+2) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale);
enum mariol  = Rectangle( ((14 * 16)-1) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale);
enum mariojr = Rectangle( ((22 * 16)+3) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale);
enum mariojl = Rectangle( (( 9 * 16)-2) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale);
auto mariospr = mariojr;

// facing direction
enum Dir {
    left,
    right
}

auto last_dir = Dir.right;

void draw_sprite(Texture tilemap, Rectangle sprite, float x, float y) {
    DrawTextureRec(tilemap, sprite, Vector2(x, y), WHITE);
}

auto level_raw =
"................................................................"~
"..........................@@@B?B@@@@@@@........................."~
"..........................@@@@@@@@@@@@@........................."~
".......@@.................@@@@@@@@.............................."~
".......@@.............############........@.@..................."~
".......BB?B..........###..................#.#.@@@@@@@..........."~
"...................###....................#.#.@@@@@@@..........."~
"..................####........................@@@@@@@..........."~
"#######################################.################.....###"~
"......................................#.#.................###..."~
"........................###############.#..............###......"~
"........................#@@@@@@@@@@@@@@@#...........###........."~
"........................#@###############........###............"~
"........................#@@@@@@@@@@@@@@@@@@@@@###..............."~
"........................######################.................."~
"................................................................";

char[width*height] level;

extern(C)
void main() {
    InitWindow(width*scale, height*scale, title);
    scope(exit) CloseWindow();
    SetTargetFPS(60);

    user_create();

    import time = core.sys.posix.sys.time;
    time.timeval last;
    time.gettimeofday(&last, null);
    while (!WindowShouldClose()) {
        BeginDrawing();
        scope(exit) EndDrawing();
        ClearBackground(CYAN);

        time.timeval now;
        time.gettimeofday(&now, null);
        // uinx specific millisecond calculation
        auto dt = ((now.tv_sec - last.tv_sec) * 1000.0 + ( now.tv_usec - last.tv_usec) / 1000.0)/1000;
        last = now;
        user_update(dt);
    }
}

void user_create() {
    // load level string into mutable array
    memcpy(level.ptr, level_raw.ptr, level_raw.length);
    // load sprites from embedded using stbi
    Image bckimg = {
        mipmaps: 1,
        format: PixelFormat.UNCOMPRESSED_R8G8B8A8,
    };

    int chan;

    bckimg.data = stbi_load_from_memory(background_raw.ptr, background_raw.length, &bckimg.width, &bckimg.height, &chan, 0);

    background = LoadTextureFromImage(bckimg);
    UnloadImage(bckimg);

    // I don't know what these are for but load_gif_from_memory needs them
    int z;
    int* delays;

    Image mimg = {
        mipmaps: 1,
        format: PixelFormat.UNCOMPRESSED_R8G8B8A8,
    };

   mimg.data = stbi_load_gif_from_memory(mario_raw.ptr, mario_raw.length, &delays, &mimg.width, &mimg.height, &z, &chan, 0);
   mario = LoadTextureFromImage(mimg);
   UnloadImage(mimg);
}

void user_update(float dt) {
    char get_tile(int x, int y) {
        if ( x >= 0 && x < levw && y >=0 && y < levh )
            return level[ y * levw + x ];
        else return ' ';

    }
    void set_tile(int x, int y, char c) {
        if ( x >= 0 && x < levw && y >=0 && y < levh )
            level[ y * levw + x ] = c;
    }

    // handle input
    //pvx = 0;
    //pvy = 0;
    moving = false;
    with(KeyboardKey) with (Dir) {
        if (IsKeyDown(KEY_UP))      pvy = -6;
        if (IsKeyDown(KEY_DOWN))    pvy =  6;
        if (IsKeyDown(KEY_LEFT)) {
            pvx += (grounded? -25 : -15 ) * dt;
            // set sprite
            mariospr = grounded? mariol : mariojl;
            last_dir = left;
            moving = true;

        }
        if (IsKeyDown(KEY_RIGHT)) {
            pvx +=  (grounded? 25 : 15 ) * dt;
            // set sprite
            mariospr = grounded? marior : mariojr;
            last_dir = right;
            moving = true;
        }
        if (IsKeyPressed(KEY_SPACE)) {
            if ( pvy == 0 ) pvy = -12;
            grounded = false;
            // set sprite
            mariospr = last_dir == left? mariojl : mariojr;
        }
    }

    // gravity
    pvy += 20 * dt;
    if (grounded) {
        // slow down x movement
        // if left/right is not pressed slow down faster
        pvx += (moving ? -3 : -7 ) * pvx * dt;
        // stop gradually
        if (math.fabs(pvx) < .01 ) pvx = 0;
    }

    pvx = algo.clamp(pvx, -10, 10);
    pvy = algo.clamp(pvy, -100, 100);

    auto newpx = px + pvx * dt;
    auto newpy = py + pvy * dt;

    // collision
    // helpers to avoid repeated casting
    auto inewpx  = cast(int)newpx;
    auto inewpy  = cast(int)newpy;
    auto ipy     = cast(int)py;
    auto shiftpy = cast(int)(py + 0.9);
    auto shiftpx = cast(int)(px + 0.9);

    char tile;
    // consume coin
    if ( (tile = get_tile(inewpx, inewpy    )) == '@' || tile == '?' || tile == 'B') {
        set_tile(inewpx, inewpy    , '.');
        if ( tile == '?' || tile == 'B' )
            bounce = true;
    } 
    if ( get_tile(inewpx, inewpy + 1) == '@') set_tile(inewpx, inewpy + 1, '.');
    if ( (tile = get_tile(inewpx + 1, inewpy)) == '@' || tile == '?' || tile == 'B') {
        set_tile(inewpx + 1, inewpy, '.');
        if ( tile == '?' || tile == 'B' )
            bounce = true;
    }
    if ( get_tile(inewpx + 1, inewpy + 1) == '@') set_tile(inewpx + 1, inewpy + 1, '.');

    if ( bounce ) {
        bounce = false;
        pvy *= -1;
    }

    // moving left
    if ( pvx <= 0 ) {
        // check left upper and lower points
       if ( get_tile( inewpx, ipy) != '.' || get_tile(inewpx, shiftpy) != '.' ) {
           newpx = cast(int)newpx + 1;
           pvx = 0;
       }
    // moving right
    } else {
        // check right upper and lower points
        if ( get_tile( inewpx + 1, ipy) != '.' || get_tile(inewpx + 1, shiftpy) != '.') {
            newpx = cast(int)newpx;
            pvx = 0;
        }
    }
    // moving up 
    if ( pvy <= 0 ) {
        // check upper left and right points
       if ( get_tile( inewpx, inewpy) != '.' || get_tile(shiftpx, inewpy) != '.' ) {
           newpy = cast(int)newpy + 1;
           pvy = 0;
       }
    // moving down
    } else {
        // check lower left and right points
        if ( get_tile( inewpx, inewpy + 1) != '.' || get_tile( shiftpx, inewpy + 1) != '.') {
            newpy = cast(int)newpy;
            pvy = 0;
            grounded = true;
            mariospr = last_dir == Dir.left? mariol : marior;
            bounce = false;
        }

    }

    px = newpx;
    py = newpy;

    camx = px;
    camy = py;

    // top left visible tile
    auto offset_x = camx - visx / 2.0;
    auto offset_y = camy - visy / 2.0;

    offset_x = algo.clamp(offset_x, 0, levw - visx);
    offset_y = algo.clamp(offset_y, 0, levh - visy);

    // smooth movement
    auto t_offx = (offset_x - math.floor(offset_x)) * tsz;
    auto t_offy = (offset_y - math.floor(offset_y)) * tsz;

    // draw level
    //ClearBackground(CYAN);
    foreach (y; 0 .. visy + 1) {
        foreach (x; 0 .. visx + 1) {
            auto xpos = ((x * tsz) - t_offx) * scale;
            auto ypos = ((y * tsz) - t_offy) * scale;
            
            switch ( get_tile( cast(int)(x + offset_x), cast(int)(y + offset_y)) ) {
                case '#':
                    // DrawRectangle(cast(int)((x * tsz) -t_offx)* scale, cast(int)((y * tsz) -t_offy) * scale, tsz * scale, tsz * scale, RED);
                    draw_sprite(background, ground, xpos, ypos);
                    break;
                case 'B':
                    draw_sprite(background, brick, xpos, ypos);
                    break;
                case '?':
                    draw_sprite(background, question, xpos, ypos);
                    break;
                case '@':
                    draw_sprite(background, coin, xpos, ypos);
                    break;
                default:break;
            }
        }

    }
    auto xpos = ((px - offset_x) * tsz) * scale;
    auto ypos = ((py - offset_y) * tsz) * scale;

    // DrawRectangle(cast(int)(((px - offset_x) * tsz) * scale), cast(int)(((py - offset_y) * tsz) * scale), tsz * scale, tsz * scale, GREEN);
    draw_sprite(mario, mariospr, xpos, ypos);
}