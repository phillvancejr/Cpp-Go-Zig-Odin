# Open GL Triangle
Hello world triangle following the [learnopengl.com](https://learnopengl.com/Getting-started/Hello-Triangle) tutorial
## C++
Simple and to the point, works perfectly and virtually all OpenGL tutorials are written for C++. C++ also has a well known library called [glm](https://glm.g-truc.net/0.9.9/index.html) which provides linear algebraic types and operations such as matrices, vectors and multiplcation between them
## Go
#### see update below

4th place. Go's C interop failed here and it could not properly recognize the dynamic glad functions so I couldn't write against the raw c api. Instead I had to use the very good [go-gl](https://github.com/go-gl/gl) and [go-gl/glfw](https://github.com/go-gl/glfw). These packages are very good and if you love go and want to do opengl then these bindings are EXCELLENT, but I want the api to look as close to C as possible so it is easy to follow tutorials and resources as I'm still learning opengl. I also like knowing exactly what the code is doing and with this wrapper I'm not exactly sure what these wrapper functions are calling or what kind of Go -> C magic/tricks they're using. I would have preferred to have been able to write the code myself so I could learn more about Go. Writing something like this is not trival because of difficulties with passing things back and forth with Cgo. In fact these packages use automation to automatically generate bindings to opengl because it is not trivial to do so manually. These packages make the code more ideomatic Go by making some functions methods which I had to find out by looking through the source repo. The weird thing is that this is not consistent and it appears that only Window has methods. The glfw functions that normally take a window * have been converted to methods while the others remain free functions. Its not very complicated but I wanted a more c like experience in terms of the api. Not to mention that of course Go is going to perform worse than the others because of the Cgo overhead. But all that beings said it got 4th place not because the Go version is bad its just that I preferred the others because there is much less between the c api and me. Again, these are excellent bindings and let you get up and running quickly. Going forward with these test I think Go is basically disqualified because I won't be using it for 3D things. Go is eliminated in this round 

#### UPDATE 04/27/22
I've been working Go more and wanted to retry the gl example. I wrote against the glfw and gl libraries on Mac directly using CGO and I am much happier with Go's implementation now. I completely understand how this works now without the (again great) bindings hidding a lot of conversions. There are more type casts, and the use of unsafe is necessary but it was very simple and easy to understand. As an added bonus the opengl2.go version dropped from the original 3.6MB (macos catalina) to 2.3MB which is nice.  Now, I'm not using glad here which means this may not work on Windows, but I'm certain that there is a simple solution using Cgo directly without having to use a library and so Go is un-eliminated and in fact after having used it for a few projects out of side this, might actually be overtaking C++ as my favorite but because it has more out of the box than C++. I'll still put it in 4th place though because it does take a bit more work to write against the C library with all the required casts compared to the other languages
## Zig
Almost identical to the C++ version. Because of Zig's great C interop, the function calls are basically one to one with the C++ version however because Zig's type system is so strong you have to be very particular about the types of variables and often casting is needed, which isn't my favorite thing. Zig has a few good game math libraries like [zalgebra](https://github.com/kooparse/zalgebra), [zlm](https://github.com/ziglibs/zlm) and zmath in the [zig-gamedev](https://github.com/michal-z/zig-gamedev) project. I'd put it at #3 because C++ doesn't require the annoying casting and strict typing
## Odin
I went in expecting Odin to win this one due to its std vendor support for opengl and I wasn't disappointed. One of the nicest things about the vendor:OpenGL library are the builtin helper functions for loading shaders which is one of the most verbose parts of OpenGL. The bindings are very easy to understand and map very closely to the C api and they're so simple that I'm confident that I could have written them myself. One feature I didn't need in this task but is definitely another plus for Odin is builtin Matrix and Vector types (vector operations are really array operations) with bulitin matrix x vector and matrix x matrix math. Also Odin has std WebGL bindings when compiling to wasm. Easily #1 in this task
### overall rankings
1. Odin
2. C++
3. Zig
4. Go
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. go</td> 
        <td>0.154s</td>
        <td>1.489s</td>
    </tr>
    <tr>
        <td>2. c++</td> 
        <td>0.233s (pch) - 0.544s</td>
        <td>1.439s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.950s</td>
        <td>2.007s</td>
    </tr>
    <tr>
        <td>4. zig</td> 
        <td>0.920s</td>
        <td style="color:red">4.896s</td>
    </tr>
</table>