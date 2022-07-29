# C++ vs Go vs Zig vs Odin vs D vs Janet vs Swift vs Nim
A series of small test programs to figure out which of the languages I like best. I don't plan on dropping C++ but I'd be willing to replace Go with Zig or Odin if I like them.

## C++
I love C++. Despite its ugly bits, its still my favorite. And programming successfully in it makes me feel like a superhero even with trivial programs
## Go
Even though it was eliminated early on, I will probably still use it for small tools using Webview because its networking support is just too good.

#### UPATE 04/27/22
Go is un-eliminated after rewriting the opengl example directly against C myself and I think that after using it for a few projects out side of this where in one case it actually replaced a previously C++ version, it might be dethroning C++ as my favorite.
## Zig
Zig is super interesting and I definitely want to explore it further. There is an imporant note on the compile times I recorded. Zig was consistently significantly slower than the others, however I actuallys poke with Andrew Kelly the creator of Zig on discord about this and He mentioned that the compile times will dramatically improve when the self hosted incremental compiler is finished which is about 66% of the way there (as of 02/13/2022). Despite its verbosity I really love the language's approach to memory management (via allocators) and error handling. Also Zig can be used as a cross compiling C and C++ (and I think also Objective C ) compiler. I've even read a couple Go articles in which Zig is used to cross compile Go applications using Cgo. It has a cool build system using the language itself as the build language. I will absolutely be playing with it more in the future.
## Odin
Odin is also awesome. It feels like the most high level out of these due to its syntax. It isn't as far along with some things like networking but it has great bindings for many game and media libraries out of the box (though on mac I had to do some manual building). Its pretty cool and I would even consider replacing Go with it since superficially they are similar. In fact once Odin gets standard networking I will revisit and consider replacing Go with it. Also I complained a lot about Odin's strong typing and strict casting, however of course this was greatly exaggerated by my misunderstanding. You can mitigate the casting by precasting things that you will use a lot, and also by using constants wherever possible as these are "untyped" and coerce to other types easily
## D
I added D during the platformer task and found it is interesting. In many ways it does improve on C++. But its kind of a pain to use in wasm which is important for me, so I won't be using it further.
## Janet
#### see upate below

I added a weird language called [Janet](https://janet-lang.org) recently. Janet is a lisp like language which can be embedded in and extended with C, similar to [Mruby](https://github.com/mruby/mruby). I had come acrossed it many times before but just wrote it off as another weird Lisp, but recently (Late Feb 2022) I've been revisiting Lisps thanks to [Bagger's awesome video](https://www.youtube.com/watch?v=6pMyhrDcMzw) of recompiling a 3d demo as it runs. I began learning Common Lisp with SBCL and had intended to use Emacs and Slime/Swank for development but... I detest Emacs. Ha ha, the bindings are just too unnatural for me coming from Vim. I know there is the Spacemacs plugin to make it more like vim but I couldn't get it to work on Mac Catalina. And so I decided to give up on Lisps for good as my thinking was that Emacs it the best Lisp environment and if I can't use the best environment I'm just not going to use it at all. Well I came to [Alive](https://lispcookbook.github.io/cl-cookbook/vscode-alive.html#optional-custom-configurations) in VSCode and a project called [Conjure](https://github.com/Olical/conjure) for [Neovim](https://neovim.io) and these worked well and were easy to set up. 

Janet is much simpler and smaller than Common Lisp and this was attractive to me. And so I decided that if I could get live reloading for Janet working like Baggers showed in his Lisp video then I'd use it. Well Janet has a package called [spork](https://github.com/janet-lang/spork) which contains, amoung other things, a SWANK like server for Janet. And so spork along with Conjure and Neovim allowed me to have my live reloading development, and so I decided to learn Janet.

Janet is awesome. Once you get passed the strange S expression syntax is it very fun. Of course complex expressions are still hard to read but to me its other merits are worth it. It comes with networking, coroutines/fibers (green threads) and real native (OS)threading, with (to my knowledge) no GIL. To me the final feature that made Janet really worth using is the fact that using its easy to install package manager [jpm](https://github.com/janet-lang/jpm) you can compile your project to standalone binaries. And the size is quite reasonable for a non systems language: the Pong example using Raylib is about 2.4MB on Mac OS Catalina. Additionally it has a great set of bindings to Raylib called [Jaylib](https://github.com/janet-lang/jaylib) which map very closely to the C api, much closer than the Commmon Lisp bindings I found. Since Janet is a small virtual machine that can be embedded in C, it should be trivial to compile it for the browser via Wasm and Emscripten, and the official documentation even mentions this. Also in the [gitter channel](https://gitter.im/janet-language/community) a user mentioned that he has successfully used the Jaylib bindings with emscripten. It has std library socket wrappers and an "official" community [http server](https://github.com/janet-lang/circlet). It even has Webview [bindings](https://github.com/janet-lang/webview), however I may write my own since these are very old and because I maintain my own fork of [Webview](https://github.com/phillvancejr/webview).

Overall I really liked Janet and I think it will be dethroning Go as my secondary language.
#### UPATE 04/27/22
I learned more about and worked with Janet last month. Toward the end I ended up writing OpenGl bindings which were quite capable though not complete. However I found compiling to wasm much more difficult than I originally thought. Compiling Janet to wasm via emscripten is quite easy, however my OpenGL bindings are a large project with many submodules and the Janet C embedding api doesn't have support for preserving this module structure when exposing bindings, that is to say that all my gl functions would be exposed in the global scope, meaning my module imports wouldn't work. The workaround is to create a dummy project structure that imports all the functions from the global scope in the proper modules, however this was much more than I wanted to do. I really liked Janet, but this event led me to abandon the gl bindings and go back to Go which I'm quite happy with now.

## Swift
Added swift on 6/1/22. I forgot about swift during the project. Swift has made a lot of progress towards cross compatibility and as of 2022, Swift runs on Mac, Linux, Windows and Wasm. On Windows a lot of effort has been invested to allow Swift to interop with the win32 api and so completely native applications can be written in pure swift for both Mac and Windows using their native bindings. Swift is not garbage collected, although technically it is since reference counting is a form of garbage collection, but it wont' suffer from GC pauses. It is a proven language, it is obviously used extensively (almost exclusively) on Mac OS for everything from Applications to games. I imagine that these days virtually all games are written in Swift for IOS and so it is a proven games programming language even though I've never seen it mentioned in discussions about games languages. I assume that Swift can't run on any consoles currently and this might be the reason it is not mentioned in game language discussions, but then again Python is quite popular amongs hobbyist and no one is even thinking of running Python on consoles.  It can't cross compile like Go or Zig unfortunately. It is really nice and looks and feels like a GC'd scripting language but compiles natively. It feels a lot like Rust without the borrow checker, and it predates Rust as far as I know.

Swift is fun and it was really nice to use. However I think the thing that might hold it back for me is that even though it is supported on Windows and Linux, I don't know of any cross platform networking api that would allow for tcp or udp servers. Though its great C interop does mean that something like SDL_Net, Enet or Mongoose could be used
## Nim
Nim is pretty cool. Its similar to Go in that it has a lot of libraries included. I'd say that interop with C is easier in Nim because the types map more closely to C. In Nim an array is the same as a C array so there is no funny business with wrapping unsafe slices like in Go. I'd say that Nim is in general better than Go for graphics, however nothing I've tested so far can beat Go's easy concurrency. So for everything except highly concurrent networking I'd say that I actaully prefer Nim over Go. Also Nim's module system is in my opinion better than Go's. Go's system requires specific file layouts and when testing a repo on github and pushing and pulling I found that I had to make sure Go wasn't caching the changes and used the latest commits which I forget how to do often, however with Nim its like Python, you just import the file and its the file that is in the import path. Nim is more complex language than Go in terms of what you can do, but in practice I found that the complexity of say macros don't really seem to show. If you're learning macros they are quite complex but they exist in many places and can be used without necessarily knowing how they are implemented. Back to Nim's C interop, you do have to write bindings, however the c2nim tool which can be installed via the nimble package manager is excellent. I was able to generate nim bindings to the emoon's [minifb ](https://github.com/emoon/minifb) library very easily and the only thing I needed to do manually was insert importing code for a single struct, and then embed the linking flags. I'd say this is better than Go because even though Go can just include C with cgo, interacting with that C from Go often involves trickery due to Go's view of C as unsafe and because Go has strict rules about passing memory back and forth with C code. 

First class compilation to Javascript is cool.

The funny thing is, I'd say that overall Nim is a better language than Go when it comes to interop with C, maybe syntax aesthetics if you care about that (I don't really), and definitely its module system, however Nim feels really generic also. It is definitely a general purpose language and doesn't really shine in any area. Go shines in networking, concurrency, compile times and simplicity and even though it brings some irritations and annoyances with things like its C interop, at least it has a reason for being. Nim is a cool language dont get me wrong, but it doesn't really feel like it has a reason to exist. Nim makes most everything easier (at least easier than C and C++) but it doesn't necessarily make anything awesome. I'd say that Nim is good for people who want a compiled language and are very concerned about how code looks. I mean I have to say I do think Nim is the best looking language of the lot. 
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
        <td name="echo server">1</td>
        <td name="build system">3</td>
        <td name="platformer">1</td>
        <td name="pong">1</td>
        <td name="total">11</td>
    </tr>
    <tr>
        <td>go</td> 
        <td name="ppm">1</td>
        <td name="http">1</td>
        <td name="opengl">4</td>
        <td name="echo server">1</td>
        <td name="build system">2</td>
        <td name="platformer">todo</td>
        <td name="pong">todo</td>
        <td name="total">9</td>
    </tr>
    <tr>
        <td>zig</td> 
        <td name="ppm">2</td>
        <td name="http">3</td>
        <td name="opengl">3</td>
        <td name="echo server">2</td>
        <td name="build system">1</td>
        <td name="platformer">4</td>
        <td name="pong">n/a</td>
        <td name="total">15</td>
    </tr>
    <tr>
        <td>odin</td> 
        <td name="ppm">1</td>
        <td name="http">4</td>
        <td name="opengl">1</td>
        <td name="echo server">2</td>
        <td name="build system">2</td>
        <td name="platformer">3</td>
        <td name="pong">1</td>
        <td name="total">14</td>
    </tr>
    <tr>
        <td>d</td> 
        <td name="ppm">n/a</td>
        <td name="http">n/a</td>
        <td name="opengl">n/a</td>
        <td name="echo server">1</td>
        <td name="build system">n/a</td>
        <td name="platformer">n/a</td>
        <td name="pong">1</td>
        <td name="total">tbd</td>
    </tr>
    <tr>
        <td>janet</td> 
        <td name="ppm">n/a</td>
        <td name="http">n/a</td>
        <td name="opengl">n/a</td>
        <td name="echo server">1</td>
        <td name="build system">n/a</td>
        <td name="platformer">n/a</td>
        <td name="pong">1</td>
        <td name="total">tbd</td>
    </tr>
    <tr>
        <td>nim</td> 
        <td name="ppm">n/a</td>
        <td name="http">1</td>
        <td name="opengl">n/a</td>
        <td name="echo server">1</td>
        <td name="build system">n/a</td>
        <td name="platformer">n/a</td>
        <td name="pong">1</td>
        <td name="total">tbd</td>
    </tr>
</table>

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