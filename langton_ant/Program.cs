using static Direction;
using static Color;
using System.Threading;

var width = 20;
var height = width;
var iterationsPerSecond = 3;
var board = new Color[width * height];
var antX = width / 2;
var antY = height / 2;
var antDir = up;
var currentMove = 0;
var running = true;

// init board 
for (var i = 0; i < board.Length; i++) {
    board[i] = white;
}
// main loop
Console.CursorVisible = false;
// handle ctrl + c
Console.CancelKeyPress += delegate {
    Console.CursorVisible = true;
};

// accept escape key to quit
Task.Run(delegate {
    while(true) {
        if (Console.ReadKey().Key == ConsoleKey.Escape) {
            running = false;
            Console.CursorVisible = true;
            break;
        }
    }
});

drawBoard();
while (running) {
    var pos = antY * width + antX;
    if (board[pos] == white) {
        turn(turnRight: true);
        board[pos] = black;
        move();
    } else {
        turn(turnRight: false);
        board[pos] = white;
        move();
    }

    wrap(ref antX);
    wrap(ref antY);
    drawBoard();
}

void turn(bool turnRight) {
    if (turnRight) {
        antDir = antDir switch {
            left => up,
            up => right,
            right => down,
            _ => left,
        };
    } else {
        antDir = antDir switch {
            left => down,
            up => left,
            right => up,
            _ => right,
        };
    }
}

void move() {
    if (antDir == left) {
        antX -= 1;
    } else if (antDir == up) {
        antY -= 1;
    } else if (antDir == right) {
        antX += 1;
    } else {
        antY += 1;
    }
}

void wrap(ref int n) {
    if (n >= width) {
        n = 0;
    } else if (n <= 0) {
        n = width = 1;
    }
}

void red(bool on) {
    Console.ForegroundColor = on switch {
        true => ConsoleColor.Red,
        _ => ConsoleColor.White
    };
}

void clearScreen() {
    Console.Clear();
}

void resetCursor() {
    Console.SetCursorPosition(0,0);
}

void drawBoard() {
    clearScreen();
    resetCursor();
    Console.WriteLine("\nmove: {0}", currentMove);
    currentMove += 1;

    for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
            if (y == antY && x == antX) {
                red(on: true);
                var symbol = antDir switch {
                    left => "<",
                    up => "A",
                    right => ">",
                    _ => "V"
                };
                Console.Write(symbol);
                red(on: false);
            } else {
                if (board[y * width + x] == white) {
                    Console.Write(".");
                } else {
                    Console.Write("#");
                }
            }
        }
        Console.WriteLine("");
    }
    Thread.Sleep(1000/iterationsPerSecond);
}

enum Direction {
    left,
    up,
    right,
    down
}

enum Color {
    white,
    black
}


