# Echo Server
A simple synchronous echo server over the local network handling a single client. There is a simple client.go that can be used to connect to the servers.
## C++
Fairly simple using Unix sockets. It has the downside of being Unix specific, but Windows has the WinSock api which is similar. I'll give it 2nd place. There are a plethora of open source networking libraries for C and C++
#### UPDATE 06/02/22
I added an Asio version which was super nice and simple. Asio to me, seemed very complicated because most tutorials immediately jump into an Object Oriented class based server and it makes following the actual Asio parts difficult. However when written in a simple manner without classes, Asio is very easy to understand and simple to use. I'd actually say this version ties with Go for first, in fact I might place it above Go tieing with Janet and bump Go down to second, though I'm sure Go would take the cake for the asynchronous version.
## Go
Go of course was very easy. 1st place becaues of ease of use and plentiful documentation
## Zig
Zig surprised me! Zig has std.net for networking but no documentation on it... except for an unlisted [talk](https://www.youtube.com/watch?v=zeLToGnjIUM&t=5s) Andrew Kelley (the Zig Creator) did for RedisConf 2020. The talk was on Async in Zig and Andrew Kelley demoed a simple multi client server which I used to figure out my implementation. There is also a library called [zig-network](https://github.com/MasterQ32/zig-network), which looks promising but I haven't tried it yet. It was really nice to use and with proper Zig error handling I liked it more than the C++ version, but because of a lack of documentation I'll have to do quite a bit of digging before I can make this work as a general networking solution. Not to mention that the api will very likely change since Zig has not yet hit 1.0, in fact the api my code uses is slightly different from the one shown in the Redis video which was uploaded in Jun 2020. That being said because of Zig's C interop I could also very easily port the C++ version to Zig and so I'll say that Zig is tied with C++ for second. Zig also has access to os.socket via the std.os library and I assume they are cross platform. I wrote a second server for zig using os.socket and it was super nice to use. I'm pretty sure os.socket is cross platform and so it gets bumped up over C++ for having cross platform networking in its std library so it ties for first with Go.
## Odin
Tied for 1st with Go. Odin surprised me here. Technically it doesn't have any networking in the std (core) library, but it does ship with SDL_Net bindings in the vendor library. The bindings are very close to the C and I was able to follow a simple [tutorial by thecplusplusguy](https://www.youtube.com/watch?v=LNSqqxIKX_k&list=PL949B30C9A609DEE8&index=57) to build the server. It is almost as short as the go example, only a few lines longer. The only downside is that on Mac and Linux you need to download and install the SDL_Net dev libraries (odin ships with SDL_Net libs for windows). In addition to this, there are third party [unix socket bindings](https://github.com/ReneHSZ/odin-sock), [bindings](https://github.com/zaklaus/odin-zeromq) to [zeromq](https://zeromq.org) and [bindings](https://github.com/librg/librg-odin) to [librg](https://librg.handmade.network), and I'll be checking these out in the future. Odin's version is nice and std networking is planned in the future but for now SDL_Net works fine and its only 57K - 64K (dynamic vs static) on Mac. Its also worth noting that odin has bindings for [Enet](http://enet.bespin.org) in its vendor library which is a UDP library specifically meant for games. Currently there is no way to override Odin's linking mechanism so that you can change which library you're linking to. For development I wouldn't mind dynamic linking to SDL_Net but for release I'd like to statically link it and there is currently a github discussion open on how this will be accomplished in a feature release. For now you have to manually modify the Odin src to link to the static version which isn't awesome but using compile time checks and flags there is a simple work around
```go
// sdl_net.odin
//...
SDL_NET_STATIC :: #config(SDL_NET_STATIC, false)
when ODIN_OS == "darwin" {
    when SDL_NET_STATIC { foreign import lib "../libs/darwin/libSDL2_net.a" }
    else { foreign import lib "system:SDL2_net" }
}
```

By default odin will link with the system's dynamic libsdl2.dylib, but you can make it static by passing a define flag 
```
odin build main.odin -define:SDL_NET_STATIC=true
```

I haven't tried it yet but I think it should work. If it does this will be a suitable solution until the official solution is implemented

## Janet
Very simple and quick to develop. Not a whole lot ot say because it was so easy. But I would say the ease of use and documentation for it make it as good as Go and actually Odin Zig and C++ should be bumped down a slot
## Rust
Rust's was actually very nice, all using builtin features. I guess it ties for first.
## Nim
Nim's was nice, though there were a few gotchas with setitng socket options to reuse ports and making sure to quit when the async work was done. I'd say it wasn't that hard to get working though so I guess it ties for first place.
### overall rankings
1. Go  Janet C++ Rust Nim (tie) 
2. Odin Zig (tie)
### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. go</td> 
        <td>0.118s</td>
        <td>1.78s</td>
    </tr>
    <tr>
        <td>2. janet</td> 
        <td>0.290s</td>
        <td>1.412s</td>
    </tr>
    <tr>
        <td>3. c++</td> 
        <td>0.474s</td>
        <td>1.039s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.792s</td>
        <td>1.395s</td>
    </tr>
    <tr>
        <td>4. zig</td> 
        <td>0.948s</td>
        <td style="color:red">4.618s</td>
    </tr>
    <tr>
        <td>5. nim</td> 
        <td>1.1s</td>
        <td>1.9s</td>
    </tr>
</table>