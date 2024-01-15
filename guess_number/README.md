# Number Guesser
Simple Console number guesser, using time seeded random number generation

## C++
C++ was shorter and simpler than the others for this simple program due to ease of working with strings and getting input with scanf
## Go
Go's implementation was also very simple. The code is about as long as the zig and odin versions due to the verbosity of error handling and the fact that you can't have single line if/else statements
## Zig
As expected zig was the most verbose and showed the complexity of string operations in the language. Zig doesn't have strings, it only has slices of bytes and so to copy into strings you have to use std.mem.copy whereas in the other langauges you can just assign the new string.
```js
var s = "string";
std.mem.copy(u8, s, "another string");
```
other 3 languages
```c++
auto s = "string";
s = "another string";
```
Zig's very strict type system showed itself even in this little program via the required @ casts in multiple places

I did like the error and optional handling seen in readNum
```js
if ( stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch return @intCast(i32,-1) ) | input |  {
        var num = input;

        if ( !std.ascii.isDigit(num[0])) std.mem.copy(u8, num, "-1");

        return std.fmt.parseInt(i32, num , 10);

    } else return @intCast(i32, -1);
```
if stdin.readUntilDelimiterOrEof returns and error we return -1 from the function, otherwise unwrap the optional it returns and capture it as `input`, however if the input is null for some reason then else also returns -1

## Odin
Odin is an odd mix of verbosity and simplicty. The code is very simple but reading from stdin is surprisingly verbose, fmt.scanf would be a welcome addition. If it wasn't for the verbosity involved in getting input and converting it the program would be very short. But even being as long as zig in terms of number of lines, the code is as simple as the go or c++ versions, except for the stdin and conversion business. Odin's or_else statement worked well for the error handling. My only gripe with it is that it cannot be used in main

## Janet
Once you get passed the S expression syntax, the Janet version is actually quite nice. And the cool thing about it is that you can use a REPL like python since it is an interpreted language. The Downside is that it is not statically typed, but overall it was pretty nice. It was simple and fast to develop thanks to the repl and good documentation. I didnt' compile this simple example (Yes you can compile Janet to standalone executables!) as it is so simple, but see some of the other demos for compile times

## Swift
Added swift on 22/6/1. The swift version is simple and it compiles decently quick. Its binaries are smaller than everyone except for c++ with the exception of Zig with `ReleaseSmall`. Very simple and the error checking for the stdinput was a one liner 
```swift
 guess = Int(readLine() ?? "-1") ?? -1
 ```
## Rust
Added Rust on 22/6/1. Going to the Dark side. The Rust version is fine, pretty simple
## C#
Not much to say, it is simple. I do really like C#'s TryParse and out params, that makes for some succinct string parse attempts.
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. c++</td> 
        <td>0.071s</td>
        <td>0.232s</td>
    </tr>
    <tr>
        <td>2. go</td> 
        <td>0.100s</td>
        <td>2.08s</td>
    </tr>
    <tr>
        <td>3. swift</td> 
        <td>0.419s</td>
        <td>0.3s</td>
    </tr>
    <tr>
        <td>4. odin</td> 
        <td>0.762s</td>
        <td>1.629s</td>
    </tr>
    <tr>
        <td>5. zig</td> 
        <td>0.903s</td>
        <td style="color:red">4.408s</td>
    </tr>
</table>

### demo
```
guess 1 - 5: 2
guess higher!
3
guess higher!
5
guess lower!
4
you got it in 4 tries
```