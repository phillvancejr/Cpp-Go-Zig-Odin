// Odin Raylib port of On Lone Coder's Code-It-Yoruself! Simpel Tile Based Platform Game
package main
import "core:fmt"
import "core:time"
import "core:math"
import "core:image/png"
import stb "vendor:stb/image"
import "vendor:raylib"

// custom colors
CYAN :: raylib.Color{ 0, 255, 255, 255 }
scale           : i32 : 4
width           : i32 : 256 
height          : i32 : 240
title           :: "OLC Tile Based Platformer - Odin"

level_width     : i32 : 64
level_height    : i32 : 16
level :[dynamic]byte

player_on_ground := false

camx := 0.0
camy := 0.0

player_x := 0.0
player_y := 0.0

player_vel_x := 0.0
player_vel_y := 0.0


// tiles
// sprites
// background tile size
bts :: 16
// characters tile size
cts :: 15
background_raw := #load("sprites/tilesx4.png")
characters_raw := #load("sprites/charactersx4.gif")
background_texture : raylib.Texture
characters_texture : raylib.Texture

block               :: raylib.Rectangle{ 0 , 1 * bts * f32(scale), bts * f32(scale), bts * f32(scale)}
coin                :: raylib.Rectangle{ 24 * 4 * bts , 1 * bts * f32(scale), bts * f32(scale), bts * f32(scale)}
mario_idle_right    :: raylib.Rectangle{ ((17 * 16)+2) * f32(scale), ((3 * 15)-1) * f32(scale) , bts * f32(scale), bts * f32(scale)}
mario_idle_left     :: raylib.Rectangle{ ((14 * 16)-1) * f32(scale), ((3 * 15)-1) * f32(scale) , bts * f32(scale), bts * f32(scale)}
mario_jump_right    :: raylib.Rectangle{ ((22 * 16)+3) * f32(scale), ((3 * 15)-1) * f32(scale) , bts * f32(scale), bts * f32(scale)}
mario_jump_left     :: raylib.Rectangle{ ((9 * 16)-2) * f32(scale), ((3 * 15)-1) * f32(scale) , bts * f32(scale), bts * f32(scale)}
mario_sprite := mario_jump_right
dir :: enum {
    left,
    right,
}
last_dir : dir = .right

user_create :: proc() {
    append(&level, "................................................................") 
    append(&level, "..........................@@@@@@@@@@@@@.........................") 
    append(&level, "..........................@@@@@@@@@@@@@.........................") 
    append(&level, ".......@@.................@@@@@@@@..............................") 
    append(&level, ".......@@.............############........@.@...................") 
    append(&level, ".......#.............###..................#.#.@@@@@@@...........") 
    append(&level, "...................###....................#.#.@@@@@@@...........") 
    append(&level, "..................####........................@@@@@@@...........") 
    append(&level, "#######################################.################.....###") 
    append(&level, "......................................#.#.................###...") 
    append(&level, "........................###############.#..............###......") 
    append(&level, "........................#@@@@@@@@@@@@@@@#...........###.........") 
    append(&level, "........................#@###############........###............") 
    append(&level, "........................#@@@@@@@@@@@@@@@@@@@@@###...............") 
    append(&level, "........................######################..................") 
    append(&level, "................................................................")
}
user_update :: proc(elapsed_time: f64) {
    using raylib
    // utility lambdas
    get_tile :: proc(x, y: i32) -> byte {
        if x >= 0 && x < level_width && y >=0 && y < level_height {
            return level[ y * level_width + x ]
        } else do return ' ';
    }

    set_tile :: proc(x, y: i32, c: byte) {
        if x >= 0 && x < level_width && y >=0 && y < level_height {
            level[ y * level_width + x ] = c
        }
    }

    // player_vel_x, player_vel_y = 0.0, 0.0

    // handle input
    if IsKeyDown(.UP)    do player_vel_y = -6.0
    if IsKeyDown(.DOWN)  do player_vel_y =  6.0
    if IsKeyDown(.LEFT) {
        player_vel_x += ( player_on_ground? -25.0 : -15.0 ) * elapsed_time
        if player_on_ground do mario_sprite = mario_idle_left
        else do mario_sprite = mario_jump_left
        last_dir = .left
    }
    if IsKeyDown(.RIGHT) {
        player_vel_x += ( player_on_ground?  25.0 :  15.0 ) * elapsed_time
        if player_on_ground do mario_sprite = mario_idle_right
        else do mario_sprite = mario_jump_right
        last_dir = .right
    }
    if IsKeyPressed(.SPACE) {
        if player_vel_y == 0 do player_vel_y = -12.0
        player_on_ground = false
        switch last_dir {
            case .left: mario_sprite = mario_jump_left
            case .right: mario_sprite = mario_jump_right
        }
    }

    player_vel_y += 20.0 * elapsed_time
    if player_on_ground {
        player_vel_x += -3.0 * player_vel_x * elapsed_time
        if abs(player_vel_x) < 0.01 do player_vel_x = 0.0
        switch last_dir {
            case .left:
                mario_sprite = mario_idle_left
            case .right:
                mario_sprite = mario_idle_right
        }
    } 

    player_vel_x = clamp(player_vel_x, -10.0, 10.0)    
    player_vel_y = clamp(player_vel_y, -100.0, 100.0)    

    new_player_x := player_x + player_vel_x * elapsed_time
    new_player_y := player_y + player_vel_y * elapsed_time


    if get_tile(i32(new_player_x), i32(new_player_y)) == '@' {
        set_tile(i32(new_player_x), i32(new_player_y), '.')
    }
    if get_tile(i32(new_player_x), i32(new_player_y + 1)) == '@' {
        set_tile(i32(new_player_x), i32(new_player_y + 1), '.')
    }
    if get_tile(i32(new_player_x + 1), i32(new_player_y)) == '@' {
        set_tile(i32(new_player_x + 1), i32(new_player_y), '.')
    }
    if get_tile(i32(new_player_x + 1), i32(new_player_y + 1)) == '@' {
        set_tile(i32(new_player_x + 1), i32(new_player_y + 1), '.')
    }

    // collision
    // if moving left
    if player_vel_x <= 0 {
        // left upper and left lower point check
        if get_tile(i32(new_player_x), i32(player_y)) != '.' || get_tile(i32(new_player_x), i32(player_y + 0.9)) != '.' {
            new_player_x = math.floor(new_player_x) + 1
            player_vel_x = 0
        }
    // moving right
    } else {
        // right upper and right lower check
        if get_tile(i32(new_player_x + 1), i32(player_y)) != '.' || get_tile(i32(new_player_x + 1),i32(player_y + 0.9)) != '.' {
            new_player_x = math.floor(new_player_x)
            player_vel_x = 0
        }
    }
    // if moving up
    // player_on_ground = true
    if player_vel_y <= 0 {
        // left upper and left lower point check
        // left upper and right upper
        if get_tile(i32(new_player_x), i32(new_player_y)) != '.' || get_tile(i32(new_player_x + 0.9), i32(new_player_y)) != '.' {
            new_player_y = math.floor(new_player_y) + 1
            player_vel_y = 0
        }
    // moving down
    } else {
        // left lower and right lower
        if get_tile(i32(new_player_x), i32(new_player_y + 1)) != '.' || get_tile(i32(new_player_x + 0.9),i32(new_player_y + 1)) != '.' {
            new_player_y = math.floor(new_player_y)
            player_vel_y = 0
            player_on_ground = true
        }
    }

    player_x = new_player_x
    player_y = new_player_y

    camx = player_x
    camy = player_y

    // draw level
    tile_w : i32 = 16
    tile_h : i32 = 16
    visible_tiles_x := width/tile_w
    visible_tiles_y := height/tile_h

    // calculate top-leftmost visible tile
    offset_x := camx - cast(f64)visible_tiles_x / 2.0
    offset_y := camy - cast(f64)visible_tiles_y / 2.0

    // clamp camera to game boudnaries
    offset_x = clamp(offset_x, 0, f64(level_width) - cast(f64)visible_tiles_x)
    offset_y = clamp(offset_y, 0, f64(level_height) - cast(f64)visible_tiles_y)

    // get offsets for smooth movement
    tile_offset_x := (offset_x - math.floor(offset_x)) * f64(tile_w)
    tile_offset_y := (offset_y - math.floor(offset_y)) * f64(tile_h)

    // draw visible tile map
    for y in 0 .. visible_tiles_y {
        for x in 0 .. visible_tiles_x {
            switch get_tile(x + i32(offset_x), y + i32(offset_y)) {
                case '.':
                    DrawRectangle( i32(f64(x * tile_w) - tile_offset_x) * scale, i32(f64(y * tile_h) - tile_offset_y) * scale, tile_w * scale, tile_h * scale, CYAN)
                case '#':
                    // DrawRectangle( i32(f64(x * tile_w) - tile_offset_x) * scale, i32(f64(y * tile_h) - tile_offset_y) * scale, tile_w * scale, tile_h * scale, RED)
                    xpos := f32((f64(x * tile_w) - tile_offset_x) * f64(scale))
                    ypos := f32((f64(y * tile_h) - tile_offset_y) * f64(scale))
                    DrawTextureRec(background_texture, block , Vector2{xpos , ypos}, WHITE)
                case '@':
                    xpos := f32((f64(x * tile_w) - tile_offset_x) * f64(scale))
                    ypos := f32((f64(y * tile_h) - tile_offset_y) * f64(scale))
                    DrawTextureRec(background_texture, coin , Vector2{xpos , ypos}, WHITE)
                case:
                    DrawRectangle( i32(f64(x * tile_w) - tile_offset_x) * scale, i32(f64(y * tile_h) - tile_offset_y) * scale, tile_w * scale, tile_h * scale, CYAN)
            }
        }
    }

    // draw player
    // DrawRectangle( i32((player_x - offset_x) * f64(tile_w)) * scale, i32((player_y - offset_y) * f64(tile_w)) * scale, tile_w * scale, tile_h * scale, GREEN)
    xpos := f32(((player_x - offset_x) * f64(tile_w)) * f64(scale))
    ypos := f32(((player_y - offset_y) * f64(tile_w)) * f64(scale))
    DrawTextureRec(characters_texture, mario_sprite, Vector2{ xpos, ypos }, WHITE)
}
main :: proc() {
    defer delete(level)
    using raylib

    i : i32 = 0
    nums: [10]i32
    nums[i] = 2

    // window
    InitWindow(width * scale,height * scale,title)
    defer CloseWindow()
    SetTargetFPS(60)
    // window

    // setup sprites
    background_image := Image{ mipmaps = 1, format = .UNCOMPRESSED_R8G8B8A8 }

    chan : i32
    background_image.data = stb.load_from_memory(raw_data(background_raw), i32(len(background_raw)), &background_image.width, &background_image.height, &chan, 0)

    background_texture = LoadTextureFromImage(background_image)
    UnloadImage(background_image)

    z: i32
    delays: [^]i32
    characters_image := Image{ mipmaps = 1, format = .UNCOMPRESSED_R8G8B8A8 }
    characters_image.data = stb.load_gif_from_memory(raw_data(characters_raw), i32(len(characters_raw)), &delays, &characters_image.width, &characters_image.height, &z, &chan, 0)

    characters_texture = LoadTextureFromImage(characters_image)
    UnloadImage(characters_image)
    // setup sprites

    user_create()
    last := time.now()

    for !WindowShouldClose() {
        BeginDrawing()
        defer EndDrawing()

        now := time.now()
        elapsed_time := time.duration_seconds(time.diff(last, now))
        last = now
        ClearBackground(CYAN)
        user_update(elapsed_time)
    }
    
}