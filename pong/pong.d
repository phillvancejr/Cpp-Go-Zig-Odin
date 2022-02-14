import deps.raylib.raylib;
import deps.stb.image;
import std.format;
import std.string;
import std.algorithm;
import core.time;

// import core.stdc.stdio;
enum width = 210;
enum height = 160;
enum scale = 4;
enum title = "Pong D";

enum padw = 10;
enum padh = 50;
auto pspeed = 100.0;
auto bspeed = 100.0;

// TODO random ball dir
auto xdir = -1.0;
auto ydir = -1.0;
float py = height / 2 - padh/2;
float cpuy = height / 2 - padh/2;
enum cpux = width - padw * 2; 
enum bsz = 10;
float bx = width/2-bsz/2;
float by = height/2-bsz/2;
auto pscore = 0;
auto cpuscore = 0;
enum maxscore = 999;
char[4] pscore_buf;
char[4] cpuscore_buf;

void main() {
    InitWindow(width*scale, height*scale, title);
    scope(exit) CloseWindow();
    SetTargetFPS(60);

    auto last = MonoTime.currTime;
    while (!WindowShouldClose()) {
        BeginDrawing();
        scope(exit) EndDrawing();

        auto now = MonoTime.currTime;

        auto dt = (now - last).total!"msecs" / 1000.0;
        last = now;
        // update
        update(dt);
        // draw
        ClearBackground(DARKGRAY);
        // scores
        draw_scores();
        // player
        rect(padw, cast(int)py, padw, padh);
        // cpu
        rect(cpux, cast(int)cpuy, padw, padh);
        // ball
        rect(cast(int)bx, cast(int)by, bsz,bsz);

        // breaking at 999 prevents undefined behaviour due to overflowing score buffer
        if ( pscore >= 999 || cpuscore >= 999 ) break;
    }
}

void update(float dt) {
    // ball movement
    bx += bspeed * dt * xdir;
    by += bspeed * dt * ydir;
    // player movement
    with(KeyboardKey) {
    if ( IsKeyDown(KEY_UP) ) py -= pspeed * dt;
    if ( IsKeyDown(KEY_DOWN) ) py += pspeed * dt;
    }
    // cpu follow ball
    cpuy = by;
    // clamp stuff
    py = clamp(py, 0.0, height-padh);
    cpuy = clamp(cpuy, 0.0, height-padh);

    // collisions
    // ceil floor
    if (by <= 0 ) ydir *= -1;
    if (by >= height - bsz) ydir *= -1;
    // score
    if (bx <= 0) pscore += 1;
    if (bx >= width - bsz) cpuscore += 1;
    // TODO restart ball

    bx = clamp(bx, 0.0, width-bsz);
    by = clamp(by, 0.0, height-bsz);

}

void rect(int x, int y, int w, int h) {
    DrawRectangle(x * scale, y * scale, w * scale, h * scale, WHITE);
}

void draw_scores() {
    // I think sprintf is better here but I'm trying learn D and this is a D way to do it
    auto pscore_str = sformat(pscore_buf[], "%03d", pscore);
    auto cpuscore_str = sformat(cpuscore_buf[], "%03d", cpuscore);
    pscore_buf[3]=0;
    cpuscore_buf[3]=0;
    DrawText(pscore_str.ptr, padw * scale, 5 * scale, 50, GRAY);
    DrawText(cpuscore_str.ptr, width * scale - (padw * 2 * scale) - 45, 5 * scale, 50, GRAY);
}