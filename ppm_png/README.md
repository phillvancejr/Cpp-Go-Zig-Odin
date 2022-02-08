# PPM PNG
Write a simple img to a ppm and optionally png. <!--Uses the first example from [ray tracing in one weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html#outputanimage)-->
Draws a 2x2 black and white checker pattern. Uses the [stb library](https://github.com/nothings/stb) for saving the png
## C++
Very simple and straight forward, no issues.
## Go
Go's implementation is interesting because Go has png writing in its standard library. To enable it I implemented the image.Image interface for my pixel buffer and then I could pass that to png.Encode and it just worked. Pretty cool, although I'm concerned that the pixel buffer might be copied at invocations of image.Image's At method becaues the reciever is a by value receiver.
## Zig
Similar to the C++ version, but unfortunately unlike stb_load_from_memory, zig cannot correctly understand the stbi_write_png function in header only mode, so I had to compile the stb library to a static library to get it to work. Not a huge deal but I had some false confidence/high expections since it did handle stb_load_from_memory in header only mode in anotehr project. Nothing to write home about, straight forward and simple
## Odin
Odin was actually similar to Go in that it has png writing capabilities in its standard library because it includes the stb libraries in its vendor library. So that is pretty nice. The implementation looks the simplest out of all the languages as i expected. The only downside (if you can call it that) was that I did have to run make to build the stb library into a static library, but that file is provided with the compiler so it was easy. I think this one might be a tie between everyone, maybe Odin, C++ and Go for first and Zig in 1.5th place
### overall rankings
1. Odin, C++, Go (tie)
2. Zig
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. go</td> 
        <td>0.100s</td>
        <td>0.881s</td>
    </tr>
    <tr>
        <td>2. c++</td> 
        <td>0.680s (ph) - 0.903s</td>
        <td>1.455s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.782s</td>
        <td>1.405s</td>
    </tr>
    <tr>
        <td>4. zig</td> 
        <td>0.909s</td>
        <td style="color:red">5.041s</td>
    </tr>
</table>

## demo
![checker](demo.png)