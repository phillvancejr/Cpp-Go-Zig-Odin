#include <stdio.h>
#include <thread>
#include <chrono>

const int width = 20;
const int height = width;

const int max_iterations = 10'000;
// up to 0 - 1000 iterations per second
// you can increase iterations to speed up the simulation and see more patterns
// but increasing it too much makes rendering look bad because the ansi functions can't keep up
const int iterations_per_second = 3;
int board[width*height]{1};

enum direction {
    left,
    up,
    right,
    down
};
// start in center
int ant_x = width / 2;
int ant_y = height / 2;
int ant_dir = up;
int current_move = 0;    

void turn_right(int& dir) {
    dir = dir == down ? left : dir+1;
}

void turn_left(int& dir) {
    dir = dir == left ? down : dir-1;
}

void move(int& ant_x, int& ant_y, int ant_dir) {
    switch ( ant_dir ) {
        case left: ant_x--;break;
        case up: ant_y--;break;
        case right: ant_x++;break;
        case down: ant_y++;break;
    }
}

void wrap(int& n) {
    if ( n >= width )
        n = 0;
    else if (n <= 0 )
        n = width - 1;
}

enum color {
    white,
    black
};

void red(bool set) {
    if (set)printf("\x1b[31m");
    else printf("\x1b[0m");
}

void clear_screen() {
    printf("\x1b[1J");
}

void reset_cursor() {
    printf("\x1b[1;1H");
}
void draw_board() {
    clear_screen();
    reset_cursor();
    printf("\nmove: %d\n", ++current_move);
    for ( auto y = 0; y < height; y++ ) {
        for ( auto x = 0; x < width; x++ ) {
            // if this is the ant
            if ( y == ant_y and x == ant_x ) {
                red(true);
                switch ( ant_dir ) {
                    case left: putchar('<'); break;
                    case up: putchar('A'); break;
                    case right: putchar('>'); break;
                    case down: putchar('V'); break;
                }
                red(false);
            } else {
                if ( board[ y * width + x ] == white)
                    putchar('.');
                else
                    putchar('#');
            }
        }
        puts("");
    }
    // delay
    std::this_thread::sleep_for(std::chrono::milliseconds(1000/iterations_per_second));
}
int main() {
    draw_board();
    while ( true ) {
        auto pos = ant_y * width + ant_x;
        if ( board[pos] == white ) {
            turn_right(ant_dir);
            board[pos] = black;
            move(ant_x, ant_y, ant_dir);
        } else {
            turn_left(ant_dir);
            board[pos] = white;
            move(ant_x, ant_y, ant_dir);
        }

        wrap(ant_x);
        wrap(ant_y);
        draw_board();
    }

}