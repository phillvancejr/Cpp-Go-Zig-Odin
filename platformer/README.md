# OLC Platformer
[One Lone Coder's tile based platformer](https://www.youtube.com/watch?v=oJvJZNyW_rw)
## C++
Simple and straight forward. The only downside to C++ I ran into here was that there is no built in way to embed resources (not until we get std::embed). But using the xxd tool it was very easy. I just did `xxd -i tilesx4.png > sprites.hpp && xxd -i charactersx4.gif >> sprites.hpp` to create arrays from the data with the length as another variable and then `#include`d them. 1st place
## Zig
At first I chose not fo finish the Zig version because I got annoyed with the type casting. There are many type casts and they are verbose to write so it adds a lot of (for me) harder to read code to do something that I know is safe but isn't allowed because the compiler doesn't think it is safe. But I wrote some helpers to make casting a little easier to read and I did like it a lot more and so finished this example. I like Zig and I think it has a bright future. It is verbose but it brings some really interesting ways of doing things. I'll definitely be keeping my eye on it and playing with it more.
## Odin
The builtin bindings for Raylib are nice but on Mac the correct libs were not set up in the raylib odin file, so I had to modify it. Also Odin is very strongly typed compared to C++ meaning that I got a lot of annoying compiler errors when trying to pass values around. For example i32 cannot implicitly convert to int, and neither can f32 to i32/int. Also some of the functions needed to take f32s and Odin's f64 cannot coerce to f32. I know this is safer but its pretty annoying. That being said it seems like C++ and C are really the only languages that allow implicit conversions. I think making this less annoying is just a matter of doing a single cast ahead of time when you know you need to reuse a casted value many times. It is not as bad a Zig but I'm not sure I want to do that much casting. 3rd place. Odin is a really nice language and I think everyone should try it out if you're looking for a C or C++ alternative. I don't know how much I'll use it right now just because of the fact that it has no std or community http server, unlike the other 3 langauges. I'll keep my eye on it and will definitely revisit when it gets either a std or community http server
## D?
A new challenger approaches! I thought I'd try D. I've heard about it, looked into it before and thought maybe it would work here as a better C++. Well I give it 2nd place because the implementation was almost exactly the same as C++, and the only reason it is second is because it required more explicit casting than C++. D is nice and purely as far as the language, I do think it improves on C++ in many ways. But if you want to compile for wasm you get very limited and inconsistent std library support. There is a programming that writes on the D blog who started a custom runtime for D wasm but its incomplete. Honestly implementing a std library is more than I want to do. I'll give it another shot in the pong example. D compiled about 4 times as fast as C++ and about 3 times as fast as Odin for this project so that is an advantage. D is interesting. It has a lot of things that are better than C++ but then there are just a ton of blunders like the way the GC was integrated and for me pervasive use of traditional exceptions. I hate try catch exception handling. But D does offer some cool things that C++ doesn't and one bonus for me personally is that it can be written in a way that is almost identical to C++ if desired, meaning I can easily port back and forth if needed. I also think this is one of the biggest reasons D is not more popular but I do think it has some cool things in it. I'm definitely going to experiment more with it
### overall rankings
1. C++
2. D 
3. Odin 
4. Zig
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cold</th>
    <th>cached</th>
    <tr>
        <td>1. d</td> 
        <td>0.264s</td>
        <td>1.980s</td>
    </tr>
    <tr>
        <td>2. odin</td> 
        <td>0.671s</td>
        <td>1.902s</td>
    </tr>
    <tr>
        <td>3. c++</td> 
        <td>0.844s</td>
        <td>0.884s</td>
    </tr>
</table>

## demo
![](demo.gif)