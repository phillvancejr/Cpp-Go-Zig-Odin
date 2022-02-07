# Http Json
Send an http get request to the star wars api for luke skywalker at  https://swapi.dev/api/people/1. Parse the returned json into a struct and print the name and eye color of the person
## C++
The http bit was easy thanks to curl, but I did have to go get a [json](https://github.com/nlohmann/json#integration) library from github. I didn't love the library and ended up only parsing into the variant like map type the library provides because I couldn't figure out how to parse it into a struct. I implemented the methods the docs said would allow this but couldn't get it to work: I really wish C++ at age 40 had std json (not to mention std networking, rip networking ts). There was also an oddity concerning the write_callback passed to curl_easy_setopt. I originally attempted to pass a non capturing lambda but got a bus error. So instead I converted it a normal function and it was fine. Because I couldn't use a lambda, had to construct a class to get nice resource management (instead of defer like the other 3), and couldn't easily parse into a struct C++ loses this one in 4th place for me personally.
## Go
The winner by far, easy built in http and json. One of the nicest things was that all of the fields did not need to be defined in the struct, only the ones I wanted to use. No contest, Go wins this.
## Zig
Pretty Good, like C++ I used libcurl but unlike C++ I was able to pass a function inline instead of needing to define a function at the global scope. Admittedly Zig's version of this is somewhat strange: you need to create an anonymous struct a method that you then pass as the function
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
It is not necessarily what you would expect, but this way, Zig manages to implement inline callbacks without introducing new syntax unlike C++. And also it actually worked, unlike the C++ lambda. The use of the c library was almost as easy C++, the only downside being the c. prefix although you could argue that this brings proper namespaces to c libraries. The issue I ran into was actually with the std.json module. Apparently json.parse can run into problems with what I assume is recursive parsing of fields and I had to use `@setEvalBranchQuota` set to a high number to prevent the error. I'm not sure if this is an intentional feature added to control the amount of branches taken, sort of like a timeout, or if it is a fix for a bug that may be fixed as the language matures. In any case I had to figure it out by searching through zig's github issues. Zig, like Odin needs more documentation, but in this test I put it in 2nd place behind Go.
## Odin
So so. Odin, doesn't currently have any http capabilities and so like Zig and C++ I decided to use libcurl. But I had to manually write bindings as odin-bindgen could not parse everything correctly ( although it might have succeeded with more work, not sure and bindgen's author is dropping support at the end of 2022). I couldn't find documentation on working with strings but figured out that I could use the strings.Builder to construct one. The json module was easy to figure out how to use, but I did have to read the std library to understand it. Fortunately because of how clean Odin code looks it wasn't a problem. Aside from the manual bindings, my only real issue with Odin here is that it just needs more thorough documentation. 3rd place
### compile times
ranked according to cached times. Didn't bother precompiling the C++ version because it was the loser for me
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
        <td>1. c++</td> 
        <td>1.951s</td>
        <td>1.997s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.974s</td>
        <td>2.110s</td>
    </tr>
    <tr>
        <td>4. zig</td> 
        <td>1.683s</td>
        <td style="color:red">5.306s</td>
    </tr>
</table>