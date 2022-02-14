
#include "raylib.h"
#include "stb_image.h"
#include <algorithm>
using std::clamp;

#include <math.h>    
// todo replace with chrono
#include <sys/time.h>

const int width = 256;
const int height = 240;
const char* title = "OLC Tile Based Platformer - C++";
const int scale = 4;
Color CYAN = { 0, 255, 255, 255 };

const int levw = 64;
const int levh = 16;
const int tsz  = 16;
const int visx = width / tsz;
const int visy = height / tsz;
float camx   = 0.0;
float camy   = 0.0;
float px     = 0.0;
float py     = 0.0;
float pvx    = 0.0;
float pvy    = 0.0;
bool grounded = false;
bool moving = false;
bool bounce = false;




// sprites
// this hpp file was generated with xxd
// it contains background_raw, background_raw_len, mario_raw & mario_raw_len
#include "sprites/sprites.hpp"

Texture background;
Texture mario;
const int bts = 16;
// background sprites
const Rectangle ground =   { 0, bts * scale, bts * scale, bts * scale };
const Rectangle coin =     { 24 * 4 * bts, bts * scale, bts * scale, bts * scale };
const Rectangle question = { 24 * 4 * bts, 0 , bts * scale, bts * scale };
const Rectangle brick =    { 22 * 4 * bts, 0 , bts * scale, bts * scale };
// mario sprites - spritesheet is poorly designed with inconsistent offsets
const Rectangle marior  = { ((17 * 16)+2) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale };
const Rectangle mariol  = { ((14 * 16)-1) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale };
const Rectangle mariojr = { ((22 * 16)+3) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale };
const Rectangle mariojl = { (( 9 * 16)-2) * scale, ((3 * 15)-1) * scale , bts * scale, bts * scale };
Rectangle mariospr = mariojr;

// facing direction
enum Dir {
    left,
    right
};

Dir last_dir = right;

void draw_sprite(Texture tilemap, Rectangle sprite, float x, float y) {
    DrawTextureRec(tilemap, sprite, Vector2{x, y}, WHITE);
}

char level[] =
"................................................................"
"..........................@@@B?B@@@@@@@........................."
"..........................@@@@@@@@@@@@@........................."
".......@@.................@@@@@@@@.............................."
".......@@.............############........@.@..................."
".......BB?B..........###..................#.#.@@@@@@@..........."
"...................###....................#.#.@@@@@@@..........."
"..................####........................@@@@@@@..........."
"#######################################.################.....###"
"......................................#.#.................###..."
"........................###############.#..............###......"
"........................#@@@@@@@@@@@@@@@#...........###........."
"........................#@###############........###............"
"........................#@@@@@@@@@@@@@@@@@@@@@###..............."
"........................######################.................."
"................................................................";

void user_create();
void user_update(float dt);

int main() {
    InitWindow(width*scale, height*scale, title);
    SetTargetFPS(60);

    user_create();

    timeval last;
    gettimeofday(&last, 0);
    while (!WindowShouldClose()) {
        BeginDrawing();
        
        ClearBackground(CYAN);

        timeval now;
        gettimeofday(&now, 0);
        // uinx specific millisecond calculation
        auto dt = ((now.tv_sec - last.tv_sec) * 1000.0 + ( now.tv_usec - last.tv_usec) / 1000.0)/1000;
        last = now;
        user_update(dt);
        EndDrawing();
    }
    CloseWindow();
}

void user_create() {
    // load level string into mutable array
    // memcpy(level.ptr, level_raw.ptr, level_raw.length);
    // load sprites from embedded using stbi
    Image bckimg = {
        .mipmaps = 1,
        .format = PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
    };

    int chan;

    bckimg.data = stbi_load_from_memory(background_raw, background_raw_len, &bckimg.width, &bckimg.height, &chan, 0);

    background = LoadTextureFromImage(bckimg);
    UnloadImage(bckimg);

    // I don't know what these are for but load_gif_from_memory needs them
    int z;
    int* delays;

    Image mimg = {
        .mipmaps= 1,
        .format= PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,
    };

   mimg.data = stbi_load_gif_from_memory(mario_raw, mario_raw_len, &delays, &mimg.width, &mimg.height, &z, &chan, 0);
   mario = LoadTextureFromImage(mimg);
   UnloadImage(mimg);
}

void user_update(float dt) {
    auto get_tile = [](int x, int y) {
        if ( x >= 0 && x < levw && y >=0 && y < levh )
            return level[ y * levw + x ];
        else return ' ';

    };
    auto set_tile = [](int x, int y, char c) {
        if ( x >= 0 && x < levw && y >=0 && y < levh )
            level[ y * levw + x ] = c;
    };

    // handle input
    //pvx = 0;
    //pvy = 0;
    moving = false;
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

    // gravity
    pvy += 20 * dt;
    if (grounded) {
        // slow down x movement
        // if left/right is not pressed slow down faster
        pvx += (moving ? -3 : -7 ) * pvx * dt;
        // stop gradually
        if (fabs(pvx) < .01 ) pvx = 0;
    }

    pvx = clamp(pvx, -10.f, 10.f);
    pvy = clamp(pvy, -100.f, 100.f);

    auto newpx = px + pvx * dt;
    auto newpy = py + pvy * dt;

    // collision
    // helpers to avoid repeated casting
    auto inewpx  = (int)newpx;
    auto inewpy  = (int)newpy;
    auto ipy     = (int)py;
    auto shiftpy = (int)(py + 0.9);
    auto shiftpx = (int)(px + 0.9);

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
           newpx = (int)newpx + 1;
           pvx = 0;
       }
    // moving right
    } else {
        // check right upper and lower points
        if ( get_tile( inewpx + 1, ipy) != '.' || get_tile(inewpx + 1, shiftpy) != '.') {
            newpx = (int)newpx;
            pvx = 0;
        }
    }
    // moving up 
    if ( pvy <= 0 ) {
        // check upper left and right points
       if ( get_tile( inewpx, inewpy) != '.' || get_tile(shiftpx, inewpy) != '.' ) {
           newpy = (int)newpy + 1;
           pvy = 0;
       }
    // moving down
    } else {
        // check lower left and right points
        if ( get_tile( inewpx, inewpy + 1) != '.' || get_tile( shiftpx, inewpy + 1) != '.') {
            newpy = (int)newpy;
            pvy = 0;
            grounded = true;
            mariospr = last_dir == left? mariol : marior;
            bounce = false;
        }

    }

    px = newpx;
    py = newpy;

    camx = px;
    camy = py;

    // top left visible tile
    float offset_x = camx - visx / 2.0;
    float offset_y = camy - visy / 2.0;

    // if (offset_x < 0) offset_x = 0;
    // if (offset_y < 0) offset_y = 0;
    offset_x = clamp(offset_x, 0.f, (float)levw - visx);
    offset_y = clamp(offset_y, 0.f, (float)levh - visy);

    // smooth movement
    auto t_offx = (offset_x - floor(offset_x)) * tsz;
    auto t_offy = (offset_y - floor(offset_y)) * tsz;
    // draw level
    //ClearBackground(CYAN);
    for (auto y = 0; y < visy + 1; y++) {
        for (auto x = 0; x < visx + 1; x++) {
            auto xpos = ((x * tsz) - t_offx) * scale;
            auto ypos = ((y * tsz) - t_offy) * scale;
            
            switch ( get_tile( (int)(x + offset_x), (int)(y + offset_y)) ) {
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

    draw_sprite(mario, mariospr, xpos, ypos);
}