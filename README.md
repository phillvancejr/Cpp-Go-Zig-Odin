# C++ vs Go vs Zig vs Odin
A series of small test programs to figure out which of the languages I like best. I don't plan on dropping C++ but I'd be willing to replace Go with Zig or Odin if I like them.

## C++
BAE. I love C++. Despite its ugly bits, its still my favorite. And programming successfully in it makes me feel like a superhero even with trivial programs
## Go
Even though it was eliminated early on, I will probably still use it for small tools using Webview because its networking support is just too good.
## Zig
Zig is super interesting and I definitely want to explore it further. There is an imporant note on the compile times I recorded. Zig was consistently significantly slower than the others, however I actuallys poke with Andrew Kelly the creator of Zig on discord about this and He mentioned that the compile times will dramatically improve when the self hosted incremental compiler is finished which is about 66% of the way there (as of 02/13/2022). Despite its verbosity I really love the language's approach to memory management (via allocators) and error handling. Also Zig can be used as a cross compiling C and C++ (and I think also Objective C ) compiler. I've even read a couple Go articles in which Zig is used to cross compile Go applications using Cgo. It has a cool build system using the language itself as the build language. I will absolutely be playing with it more in the future.
## Odin
Odin is also awesome. It feels like the most high level out of these due to its syntax. It isn't as far along with some things like networking but it has great bindings for many game and media libraries out of the box (though on mac I had to do some manual building). Its pretty cool and I would even consider replacing Go with it since superficially they are similar. In fact once Odin gets standard networking I will revisit and consider replacing Go with it.
## *D
I added D during teh platformer task and found itD is interesting. In many ways it does improve on C++. But its kind of a pain to use in wasm which is important for me, so I won't be using it further.
## My rankings 
lower score is better. No scores for the trival programs like Battle and Guess Number
<table>
    <th>lang</th>
    <th>ppm & png</th>
    <th>http & json</th>
    <th>opengl</th>
    <th>echo server</th>
    <th>build system</th>
    <th>platformer</th>
    <th>pong</th>
    <th>total</th>
    <tr>
        <td>c++</td> 
        <td name="ppm">1</td>
        <td name="http">2</td>
        <td name="opengl">2</td>
        <td name="echo server">2</td>
        <td name="build system">3</td>
        <td name="platformer">1</td>
        <td name="pong">1</td>
        <td name="total">12</td>
    </tr>
    <tr>
        <td>go</td> 
        <td name="ppm">1</td>
        <td name="http">1</td>
        <td name="opengl">4</td>
        <td name="echo server">1</td>
        <td name="build system">2</td>
        <td name="platformer">eliminated</td>
        <td name="pong">eliminated</td>
        <td name="total">9</td>
    </tr>
    <tr>
        <td>zig</td> 
        <td name="ppm">2</td>
        <td name="http">3</td>
        <td name="opengl">3</td>
        <td name="echo server">1</td>
        <td name="build system">1</td>
        <td name="platformer">4</td>
        <td name="pong">n/a</td>
        <td name="total">14</td>
    </tr>
    <tr>
        <td>odin</td> 
        <td name="ppm">1</td>
        <td name="http">4</td>
        <td name="opengl">1</td>
        <td name="echo server">1</td>
        <td name="build system">2</td>
        <td name="platformer">3</td>
        <td name="pong">1</td>
        <td name="total">13</td>
    </tr>
    <tr>
        <td>d</td> 
        <td name="ppm">n/a</td>
        <td name="http">n/a</td>
        <td name="opengl">n/a</td>
        <td name="echo server">n/a</td>
        <td name="build system">n/a</td>
        <td name="platformer">1</td>
        <td name="pong">1</td>
        <td name="total">tbd</td>
    </tr>
</table>

TODO
- [X] Guess Number
- [X] Http and Json
- [X] Langton's Ant
- [X] PPM and PNG
- [X] Text Battle Simulation
- [X] Build System
- [X] Echo Server
- [X] OpenGL Triangle
- [X] Mini Platformer - One Lone Coder port
- [X] Pong