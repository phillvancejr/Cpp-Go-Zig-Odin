package main

import (
	"fmt"
	"time"
)
const (
	width = 20
	height = width
	maxIterations = 10_000
	// up to 0 - 1000 iterations per second
	// you can increase iterations to speed up the simulation and see more patterns
	// but increasing it too much makes rendering look bad because the ansi functions can't keep up
	iterationsPerSecond = 3
)

type Direction int
const (
	// directions
	left Direction = iota
	up
	right
	down
)

const (
	white = iota
	black
)

var (
	board [width * height]int
	// start in center
	antX = width / 2
	antY = height / 2
	antDir = up
	currentMove = 0
)

func main() {
	// init board to 0
	for _, i := range board {
		board[i]=white
	}

    drawBoard()
    for true  {
        pos := antY * width + antX
        if board[pos] == white {
            turnRight(&antDir)
            board[pos] = black
            move(&antX, &antY, antDir)
        } else {
            turnLeft(&antDir)
            board[pos] = white
            move(&antX, &antY, antDir)
        }

        wrap(&antX)
        wrap(&antY)
        drawBoard()
    }
}

func turnRight(dir *Direction) {
	if *dir == down {
		*dir = left
	} else {
		*dir += 1
	}
}

func turnLeft(dir *Direction) {
	if *dir == left {
		*dir = down
	} else {
		*dir -=1
	}
}

func move(antX, antY *int, antDir Direction) {
    switch antDir  {
        case left: 
			*antX -= 1
        case up: 
			*antY -= 1
        case right: 
			*antX += 1
        case down: 
			*antY += 1
    }
}

func wrap(n *int) {
    if  *n >= width  {
        *n = 0;
	} else if *n <= 0 {
        *n = width - 1;
	}
}

func red(set bool) {
	if set {
		fmt.Print("\033[31m")
	} else {
    	fmt.Print("\033[0m")
	}
}

func clearScreen() {
    fmt.Print("\x1b[1J")
}

func resetCursor() {
    fmt.Print("\x1b[1;1H")
}

func drawBoard() {
    clearScreen()
    resetCursor()
    fmt.Printf("\nmove: %d\n", currentMove)
	currentMove += 1
    for y := 0; y < height; y += 1 {
        for x := 0; x < width; x += 1 {
            // if this is the ant
            if y == antY && x == antX  {
                red(true)
                switch antDir {
                    case left: 
						fmt.Print("<")
                    case up: 
						fmt.Print("A")
                    case right: 
						fmt.Print(">")
                    case down: 
						fmt.Print("V")
                }
                red(false)
            } else {
                if board[ y * width + x ] == white {
                    fmt.Print(".")
				} else {
                    fmt.Print("#")

				}
            }
        }
		fmt.Println("")
    }
    // delay
	time.Sleep(time.Millisecond * (1000/iterationsPerSecond))
}