# Http Json
Send an http get request to the star wars api for luke skywalker at  https://swapi.dev/api/people/1. Parse the returned json into a struct and print the name and eye color of the person
## C++
The http bit was easy thanks to curl, but I did have to go get a [json](https://github.com/nlohmann/json#integration) library from github. At first I didn't love the library and ended up only parsing into the variant like map type the library provides because I couldn't figure out how to parse it into a struct. But then I decided to try again and I found a nice macro in the library that actually implements the methods for you and this was really slice and even allowed me to only specify the fields I wanted info from. There was also an oddity concerning the write_callback passed to curl_easy_setopt. I originally attempted to pass a non capturing lambda but got a bus error. So instead I converted it a normal function and it was fine. But a stack overflow answer informed me that I can use the `+` operator to forcefully cast a non capturing C++ lambda to its C equivalent, which is something I was not aware of. The C++ version ended up very nice and I put in 2nd after go
## Go
The winner by far, easy built in http and json. One of the nicest things was that all of the fields did not need to be defined in the struct, only the ones I wanted to use. No contest, Go wins this.
## Zig
Pretty Good, like C++ I used libcurl and also passed a function inline. Admittedly Zig's version of this is somewhat strange: you need to create an anonymous struct a method that you then pass as the function
```js
fn doSomething(f: fn()void) void {
    f();
}

pub fn main() void {
    doSomething(struct{ // <- anonymous struct
        fn call() void {
            // do stuff
        }
    }.call); // <- NOTE we pass the struct member function using the field
}
```
It is not necessarily what you would expect, but this way, Zig manages to implement inline callbacks without introducing new syntax unlike C++. And also it actually worked, unlike the C++ lambda. The use of the c library was almost as easy C++, the only downside being the c. prefix although you could argue that this brings proper namespaces to c libraries. The issue I ran into was actually with the std.json module. Apparently json.parse can run into problems with what I assume is recursive parsing of fields and I had to use `@setEvalBranchQuota` set to a high number to prevent the error. I'm not sure if this is an intentional feature added to control the amount of branches taken, sort of like a timeout, or if it is a fix for a bug that may be fixed as the language matures. In any case I had to figure it out by searching through zig's github issues. Zig, like Odin needs more documentation, and I put Zig in 3rd place just becaues I didn't have to write any bindings unlike Odin.
## Odin
Not bad. Odin, doesn't currently have any http capabilities and so like Zig and C++ I decided to use libcurl. I needed to write bindings and decided to use the odin-bindgen project which can create odin bindings from a C header file. The tool isn't perfect but the best way I found to work with it is to put the definitions you need into a file and only generate bindings on that instead of trying to work on an enormous file with potentially crazy C macro funny business. It worked well. I couldn't find documentation on working with strings but figured out that I could use the strings.Builder to construct one. The json module was easy to figure out how to use, but I did have to read the std library to understand it. Fortunately because of how clean Odin code looks it wasn't a problem. Aside from the manual bindings, my only real issue with Odin here is that it just needs more thorough documentation. 4th place only because I had to write bindings even though they were very easy thanks to odin bindgen. It is worth noting that the author of odin-bindgen will end support for it at the end of 2022, so it may need to be forked and maintained.
## *Swift
Swift's is very easy to use and built in, tied with Go
## *Rust
(sigh...) I mean, it works right lol. Rust's implementation looks really simple and is the shortest at 12 lines. But Rust takes so long to compile, so long. My release build took 1m and 14s to build and gave me a 4.2MB exectuable, 2.9MB stripped, probably due to the enormous quantity of dependencies that I watched as a cascading green wall while compiling. As a plus, it's smaller than the Go version which is 6.4MB, but now we're comparing a low level sytem language (Rust) to a GC'd language (Go) so I'm not sure Rust being smaller than Go is much of a compliment. Still, the code itself is very nice. Its worth noting that I have done enough Rust to not be bothered by the borrow checker, compile times and C interop friction (unsafe!) are the main pain points I have with Rust. For debug it compiled faster than Zig, but with a 15MB executable so, release is all I tracked in the rankings below.
## Nim
Nim's version is really short and simple. I'm surprised that I actaully liked it more than Go, so first place for Nim!
### overall rankings
1. Nim
2. Go & Swift
3. C++
4. Zig
5. Odin
### compile times
ranked according to cached times.
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. go</td> 
        <td>0.171s</td>
        <td>2.447s</td>
    </tr>
    <tr>
        <td>2. swift</td> 
        <td>0.4s</td>
        <td>1.174s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.974s</td>
        <td>2.110s</td>
    </tr>
    <tr>
        <td>4. nim</td> 
        <td>1.5ish</td>
        <td>2.382s</td>
    </tr>
    <tr>
        <td>3. zig</td> 
        <td>1.683s</td>
        <td style="color:red">5.306s</td>
    </tr>
    <tr>
        <td>5. rust</td> 
        <td>1.895s</td>
        <td style="color:red"kj>8.537s</td>
        <td style="color:red">First Release Build - 1m 14s</td>
    </tr>
    <tr>
        <td>6. c++</td> 
        <td>1.951s</td>
        <td>1.997s</td>
    </tr>
</table>