# [Langton's Ant](https://en.wikipedia.org/wiki/Langton's_ant)
A Celluar Automata  in which an ant traverses a grid while creating various patterns. In this project I use the console and ansi escape codes for the drawing

## C++
One advantage of C++ over Go and Odin in this task is the fact that you can initialize an array with any value by supplying a single value
```c++
// initialize board with all values set to 1
int board[width*height]{1};
```
It is a little shorter than Zig's version

One disadvantage of C++ compared to the other languages is that you cannot use type inference for variables at the global scope. In C++ we have `auto` for type inference, but it only works inside functions for variables. All 3 of the other languages can infer the type of global variables. This is not a huge deal but it is a nice convenience of those other languages

Another disadvantage which is actually inconvenient is that C++ requires forward declaration for functions whereas the other 3 allow you to define functions and globals anywhere. 
## Go
Unlike the others, in Go you cannot initialize all the values of an array without an array literal or loop. Not only do you have to use a loop to initialize the values but this must be done at runtime, whereas not only can C++, Zig and Odin easily initialize an array but it can be done at compile time. I don't love Go's camelCase convention/enforcement
## Zig
Zig can also initialize an array to any value very easily
```js
const board = [_]i32{1} ** ( width * height )
```
Functions are camelCase by convention but variables are snake_case. I don't like camelCase at all, but I'll admit this does make it clear what an identifier means.

Zig is the only language of the 4 that allows if as expressions which can be seen in the next and prev functions
```js
fn prev(self: @This()) Direction {
    const val = @enumToInt(self);
    return if ( val <= 0 ) .down
    else @intToEnum(Direction, val-1);
}
```
Here return uses an if expression. It can also be used to assign values directly
```js
const val = if ( true ) 1 else 2;
```
C++ acomplishes the same thing with the ternary operator ?, but Odin and Go do not have a way to do this

I like Zig's switch syntax the most out of the 4, although it is not as flexible in terms of types as Go and Odin

One thing that is kind of annoying with Zig is that function parameters cannot shadow globals which means that I could not refer to ant_x as such in the move function unlike the other languages. That being said I'll admit that while somewhat inconvenient it is actually safer and more logical because in Zig you never lose access to the global, whereas in Go and Odin you cannot refer to the global anymore because of the shadowing. C++'s solution to this is the scope resolution operator which would allow you to get the global ant_x with ::ant_x inside the move function

I also don't like Zig's while loop. I prefer the traditional C for loop because the initialization is part of the construct, whereas with Zig you must define the initial value outside of the while. In another test for drawing pixels, I found it was easy to forget to increment values for loops since it is not part of the loop definition

Zig's type inferrence is ok but vars often cannot be inferred meaning you have to either use @as or specify the type which makes the code more verbose
```js
var i: i32 = 0;
while( i < 10 ) : ( i += 1 )
```
## Odin
In this task I found Odin's syntax very pleasing to look at and write. It is very easy to read and is a joy to write 

Like C++ and Zig, Odin is also able to initialize an array at compile time easily.
```go
board :: [?]int{ 0..width*height=1 }
```
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. go</td> 
        <td>0.103s</td>
        <td>0.752s</td>
    </tr>
    <tr>
        <td>2. c++</td> 
        <td> 0.141s (pch) - 0.346s</td>
        <td>0.675s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.741s</td>
        <td>1.673s</td>
    </tr>
    <tr>
        <td>4. zig</td> 
        <td>0.916s</td>
        <td style="color:red">5.057s</td>
    </tr>
</table>

### demo
width = 20, max_iterations = 10,000
<pre style="color:white">
move: 4048
#..........#........
.........##.........
....##..#..#..##....
...#..#..#..#####...
..###...#....###.#..
..#.######...#####..
.........###....#...
....######...#.##.#.
.....####<span style="color:red"><</span>..#...###.
......#..##.##....#.
......#..##.......#.
#.....#..######..#.#
........##.....##...
.....#.....####.#...
.....#.##.....###...
......##....#..#....
.......##....##.....
....................
....................
...........#........
</pre>

## Ada
The first time I wrote this program it was actually in Ada. Ada has a really cool type system which allows you to do things like declare that the ant's x and y values are modulo types of the board size meaning they wrap automatically in both directions in case of under/overflow. Additionally you can do things like define a type as a range of values such that the directions could be a range of int 0 .. 4 so you would get the strong typing of the new type and any value outside of the range would be an error. Unfortunately none of the other languages have these features but I thought it was worth noting as it is something I missed in this task. If I only wanted to target the desktop I might actually use Ada, but its support for wasm and the browser is: in its infancy, complicated to set up, and I don't expect it to progress anytime soon. Also Ada is even more verbose than Zig and doesn't have many conveniences or niceties in the language. Zero type inference and no anonymous functions make it very verbose and it also uses exceptions which I don't like, although its version is at least more convenient to use than C++, JS, Python, Java etc.

Ada has good C interop though and a tool to generate Ada bindings from C headers comes with the compiler tool chain. 
