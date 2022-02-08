# Build System
Testing build systems for the languages by linking to a c library. I'll use this simple c function in a static library
```c
int add_five(int num){ return num + 5; }
```
For C++, Go and Zig this is a silly example because all 3 could just directly import add.c but it illustrates how it would work with more complex libraries that maybe have been pre built
## C++
C++ doesn't have a standardized way of linking to libraries in the langauge (windows compilers have a #pragma for it), and build systems are platform specific. I'm on Mac so I used a makefile and windows would use a .bat file or a visual studio solution/project. There is also Cmake which is slightly more cross platform, sort of, but it will produce a makefile anyway so I just used that. Technically Cmake is a decent solution given the current state of C++ building, but C++ is definitely last place in this task because as the other languages show, it could be much easier.
## Go
Go like Odin don't really use an external build system, instead linking to other code is built into the langauge via the package system or Cgo for C in the case of Go
## Zig
As mentioned above Zig, like C++ and Go could just include the add.c file and it would work. I could also add C source files in the build.zig
```js
exe.addCSourceFile("add.c", &[_][]const u8);
```
## Odin
Similar to Go the package system functions as the build system and the foreign import constructs can be used for C. Unfortunately you must write manual bindings, though this can be aided with [odin-bindgen](https://github.com/Breush/odin-binding-generator)
### overall rankings
Zig is in 1st because its build system uses Zig. I tied Odin and Go for 2nd, Go dropped to 2nd because even though it is easy to link with C, it has an overhead for calling into it, and Odin dropped to 2nd because you have to write manual bindings. C++ is last because building is not standardized and the best solutions all require learning a new scripting language
1. Zig
2. Odin Go (tie)
3. C++
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. c++</td> 
        <td>0.098s</td>
        <td>0.469s</td>
    </tr>
    <tr>
        <td>2. go</td> 
        <td>0.125s</td>
        <td>1.005s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.697s</td>
        <td>1.307s</td>
    </tr>
    <tr>
        <td>4. zig</td> 
        <td>1.156s</td>
        <td style="color:red">6.922s</td>
    </tr>
</table>