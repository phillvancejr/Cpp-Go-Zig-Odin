import Foundation

typealias i32 = Int32
typealias f32 = Float32

let scale: i32 = 4
let width: i32 = 210 * scale
let height: i32 = 160 * scale
let title = "Pong Swift"

let padw = 10 * scale
let padh = 50 * scale

var py = f32( height / 2 - padh / 2 )
var cpuy = py
let cpux = width-padw*2
let pspeed: f32 = 400

// ball
var xdir: f32 = 0
var ydir: f32 = 0
var bx: f32 = 0
var by: f32 = 0
let bsz = 10 * scale
let bspeed: f32 = 300

// score
var pscore = 0
var cpuscore = 0

SetTraceLogLevel(i32(LOG_NONE.rawValue))
InitWindow(width, height, title)
defer{ CloseWindow() }
SetTargetFPS(60)

reset_ball()

while !WindowShouldClose() {
    BeginDrawing()
    defer{ EndDrawing() }

    ClearBackground(dark_gray)
    // update
    update(GetFrameTime())
    // scores
    draw_scores()
    // player
    rect(padw, i32(py), padw, padh)
    // cpu
    rect(cpux, i32(cpuy), padw, padh)
    // ball
    rect(i32(bx), i32(by), bsz, bsz)
}

func draw_scores() {
    DrawText(String(format: "%03d", pscore), padw, 5 * scale, 50, gray)
    DrawText(String(format: "%03d", cpuscore), width - (padw * 2) - 45, 5 * scale, 50, gray)
}

func clamp(_ val: f32, _ min: i32, _ max: i32) -> f32 {
    let min = f32(min)
    let max = f32(max)

    if val < min {
        return min
    } else if val > max {
        return max
    } else {
        return val
    }
}

func update(_ dt: f32) {
    // ball movement
    bx += bspeed * dt * xdir
    by += bspeed * dt * ydir
    // player movement
    if IsKeyDown(i32(KEY_UP.rawValue)) { py -= pspeed * dt }
    if IsKeyDown(i32(KEY_DOWN.rawValue)) { py += pspeed * dt }
    // cpu follow ball
    cpuy = by / 2;
    // clamp stuff
    py = clamp(py, 0, height - padh)
    cpuy = clamp(cpuy, 0, height-padh)
    // collisions
    // ceil floor
    if by <= 0 { ydir *= -1 }
    if by >= f32(height - bsz) { ydir *= -1 }
    // score
    if bx <= 0 { 
        cpuscore += 1
        reset_ball()
    }
    if bx >= f32(width - bsz) {
        pscore += 1
        reset_ball()
    }
    // paddle collision cpu

    bx = clamp(bx, 0, width-bsz)
    by = clamp(by, 0, height-bsz)

    // paddle collision player
    if xdir == -1 && (bx <= f32(padw * 2) && by >= py && by <= py + f32(padh)) {
        xdir = 1
    }
    if xdir == 1 && (bx + f32(bsz) >= f32(cpux) && by >= cpuy && by <= cpuy + f32(padh)) {
        xdir = -1
    }

    // max score
    if pscore >= 999 || cpuscore >= 999 { break }
}

func rect(_ x: i32, _ y: i32, _ w: i32, _ h: i32) {
    DrawRectangle(x, y, w, h, white)
}

func reset_ball() {
    xdir = Bool.random() ? 1 : -1
    ydir = Bool.random() ? 1 : -1
    bx = f32(width/2-bsz/2)
    by = f32(height/2-bsz/2)
}