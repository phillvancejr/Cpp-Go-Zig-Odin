#include "raylib.h"
#include "stb_image.h"
#include <chrono>
#include <algorithm>
#include <stdio.h>
#include <stdlib.h>

const int width = 210;
const int height = 160;
const int scale = 4;
const char* title = "Pong C++";

const int padw = 10;
const int padh = 50;
float pspeed = 100;
float bspeed = 100;

// TODO random ball dir
float py = height/2-padh/2;
float cpuy = py;
const int cpux = width-padw*2;
const int bsz = 10;
float xdir{};
float ydir{};
float bx{};
float by{};
int pscore = 0;
int cpuscore = 0;
const int maxscore = 999;
char pscore_buf[4];
char cpuscore_buf[4];

void update(float dt);
void rect(int x, int y, int w, int h);
void draw_scores();
void reset_ball();

int main() {
    InitWindow(width*scale, height*scale, title);
    SetTargetFPS(60);

    auto last = std::chrono::system_clock::now().time_since_epoch();
    srand(last.count());
    reset_ball();

    while ( !WindowShouldClose() ) {
        BeginDrawing();

        ClearBackground(DARKGRAY);

        auto now = std::chrono::system_clock::now().time_since_epoch();
        auto dt = std::chrono::duration_cast<std::chrono::milliseconds>(now - last).count() / 1000.0;
        last = now;
        // update
        update(dt);
        // scores
        draw_scores();
        // player
        rect(padw, py, padw, padh);
        // cpu
        rect(cpux, cpuy, padw, padh);
        // ball
        rect(bx, by, bsz,bsz);

        // breaking at 999 prevents undefined behaviour due to overflowing score buffer
        if ( pscore >= 999 || cpuscore >= 999 ) break;

        EndDrawing();
    }
    CloseWindow();
}

void draw_scores() {
    sprintf(pscore_buf, "%03d", pscore);
    sprintf(cpuscore_buf, "%03d", cpuscore);
    DrawText(pscore_buf, padw * scale, 5 * scale, 50, GRAY);
    DrawText(cpuscore_buf, width * scale - (padw * 2 * scale) - 45, 5 * scale, 50, GRAY);
}

void rect(int x, int y, int w, int h) {
    DrawRectangle(x * scale, y * scale, w * scale, h * scale, WHITE);
}
void reset_ball() {
    xdir = (rand() % 2) == 0 ? 1 : -1 ;
    ydir = (rand() % 2) == 0 ? 1 : -1 ;
    bx = width/2-bsz/2;
    by = bx;
}

void update(float dt) {
    // ball movement
    bx += bspeed * dt * xdir;
    by += bspeed * dt * ydir;
    // player movement
    if ( IsKeyDown(KEY_UP) ) py -= pspeed * dt;
    if ( IsKeyDown(KEY_DOWN) ) py += pspeed * dt;
    // cpu follow ball
    cpuy = by / 2;
    // clamp stuff
    py = std::clamp(py, 0.f, (float)height-padh);
    cpuy = std::clamp(cpuy, 0.f, (float)height-padh);

    // collisions
    // ceil floor
    if (by <= 0 ) ydir *= -1;
    if (by >= height - bsz) ydir *= -1;
    // score
    if (bx <= 0) { 
        cpuscore += 1;
        reset_ball();
    }
    if (bx >= width - bsz) {
        pscore += 1;
        reset_ball();
    }
    // paddle collision cpu

    bx = std::clamp(bx, 0.f, (float)width-bsz);
    by = std::clamp(by, 0.f, (float)height-bsz);

    // paddle collision player
    if (xdir == -1 and (bx <= padw * 2 and by >= py and by <= py + padh)) {
        xdir = 1;
    }
    if (xdir == 1 and (bx + bsz >= cpux and by >= cpuy and by <= cpuy + padh)) {
        xdir = -1;
    }
}