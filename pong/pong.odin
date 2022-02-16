package main

import "vendor:raylib"
import "core:fmt"
import "core:time"
import "core:strings"
import "core:math/rand"

width :: 210
height :: 160
scale :: 4
title :: "Pong Odin"

padw :: 10
padh :: 50
pspeed :: 100.0
bspeed :: 100.0

// TODO pick random ball start dir
xdir := -1.0
ydir := -1.0
py := height/2 -padh/2.0
cpuy := height/2 -padh/2.0
cpux :: width - padw * 2
bsz :: 10
bx := width/2 - bsz/2.0
by := height/2 - bsz/2.0
pscore := 0
cpuscore := 0

pscore_buf : [4]u8
cpu_score_buf : [4]u8

main :: proc() {

    using raylib
    InitWindow(width*scale, height*scale, title)
    defer CloseWindow()
    SetTargetFPS(60);

    last := time.now()

    for !WindowShouldClose() {
        BeginDrawing()
        defer EndDrawing()

        now := time.now()
        dt := time.duration_seconds(time.diff(last,now))
        last = now
        fmt.println("DT:", dt)
        // update
        update(dt)
        // draw
        ClearBackground(DARKGRAY)
        // draw scores
        draw_scores()
        // draw player
        rect(padw, i32(py), padw, padh)
        // draw cpu
        rect(cpux, i32(cpuy), padw, padh)
        // draw ball
        rect(i32(bx), i32(by), bsz, bsz)
        // fmt.printf("%03d\n", pscore)

    }
}

update :: proc(dt: f64) {
    rand.set_global_seed(cast(u64)time.since(time.Time{0}))
    using raylib
    // ball movement
    bx += bspeed * dt * xdir
    by += bspeed * dt * ydir
    // player movement
    if IsKeyDown(.UP) do py -= pspeed * dt
    if IsKeyDown(.DOWN) do py += pspeed * dt
    // cpu follow ball
    cpuy = by / 2
    // clamp everything
    py = clamp(py, 0.0, height-padh)
    cpuy = clamp(cpuy, 0.0, height-padh)

    // collisions
    // ceil floor
    if by <= 0.0 do ydir *= -1
    if by >= height - bsz do ydir *= -1
    // score
    if bx <= 0.0 {
        cpuscore += 1
        reset_ball()
    } 
    if bx >= width - bsz {
        pscore += 1
        reset_ball()
    }

    bx = clamp(bx, 0.0, width-bsz)
    by = clamp(by, 0.0, height-bsz)

    if xdir == -1 && (bx <= padw * 2 && by >= py && by <= py + padh) {
        xdir = 1;
    }
    if xdir == 1 && (bx + bsz >= cpux && by >= cpuy && by <= cpuy + padh) {
        xdir = -1;
    }
}

rect :: proc(x, y, w, h: i32) {
    using raylib
    DrawRectangle(x * scale, y * scale, w * scale, h * scale, WHITE)
}

reset_ball :: proc() {
    xdir = (rand.int_max(2)) == 0 ? 1 : -1
    ydir = (rand.int_max(2)) == 0 ? 1 : -1
    bx = width/2-bsz/2.0
    by = by
}

draw_scores :: proc() {
    using raylib
    pscore_str := fmt.bprintf(pscore_buf[:], "%03d", pscore)
    cpu_score_str := fmt.bprintf(cpu_score_buf[:], "%03d", cpuscore)

    DrawText(strings.unsafe_string_to_cstring(pscore_str), padw * scale, 5 * scale, 50, GRAY)
    DrawText(strings.unsafe_string_to_cstring(cpu_score_str), width * scale - (padw * 2 * scale) - 45, 5 * scale, 50, GRAY)
}
