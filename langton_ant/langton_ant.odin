package main

import "core:fmt"
import "core:time"

width :: 20
height :: width
max_iterations :: 10_000
// up to 0 - 1000 iterations per second
// you can increase iterations to speed up the simulation and see more patterns
// but increasing it too much makes rendering look bad because the ansi functions can't keep up
iterations_per_second :: 3

 // directions
left :: 0
up :: 1
right :: 2
down :: 3

color :: enum {
    white,
    black,
}

board := [?]color{ 0..width*height=.white }
// start in center
ant_x := width / 2
ant_y := height / 2
ant_dir := up
current_move := 0

main :: proc() {
    fmt.println(current_move)
    draw_board()
    for true  {
        pos := ant_y * width + ant_x
        if board[pos] == .white {
            turn_right(&ant_dir)
            board[pos] = .black
            move(&ant_x, &ant_y, ant_dir)
        } else {
            turn_left(&ant_dir)
            board[pos] = .white
            move(&ant_x, &ant_y, ant_dir)
        }

        wrap(&ant_x)
        wrap(&ant_y)
        draw_board()
    }
}

turn_right :: proc(dir: ^int) {
	if dir^ == 3 do dir^ = 0
	else do dir^ += 1
}

turn_left :: proc(dir: ^int) {
	if dir^ == 0 do dir^ = 3
	else do dir^ -= 1
}

move :: proc(ant_x: ^int, ant_y: ^int, ant_dir: int) {
    switch ant_dir {
        case left: ant_x^ -= 1
        case up: ant_y^ -= 1
        case right: ant_x^ += 1
        case down: ant_y^ += 1
    }
}

wrap :: proc(n: ^int) {
    if n^ >= width do n^ = 0
    else if n^ <= 0 do n^ = width - 1
}

red :: proc(set: bool) {
    if set do fmt.print("\033[31m")
    else do fmt.print("\033[0m")
}

clear_screen :: proc() {
    fmt.print("\x1b[1J")
}

reset_cursor :: proc() {
    fmt.print("\x1b[1;1H")
}

draw_board :: proc() {
    clear_screen()
    reset_cursor()
    fmt.printf("\nmove: %d\n", current_move)
	current_move += 1
    for y := 0; y < height; y += 1 {
        for x := 0; x < width; x += 1 {
            // if this is the ant
            if y == ant_y && x == ant_x  {
                red(true)
                switch ant_dir {
                    case left: fmt.print("<")
                    case up: fmt.print("A")
                    case right: fmt.print(">")
                    case down: fmt.print("V")
                }
                red(false)
            } else {
                if board[ y * width + x ] == .white {
                    fmt.print(".")
				} else {
                    fmt.print("#")

				}
            }
        }
		fmt.println("")
    }
    // delay
	time.sleep(time.Millisecond * (1000/iterations_per_second))
}