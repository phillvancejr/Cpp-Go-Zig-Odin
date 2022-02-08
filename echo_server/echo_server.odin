package main

import "core:fmt"
import "vendor:sdl2/net"
import "core:strings"

port :: 8000

main :: proc() {
    net.Init()
    defer net.Quit()

    ip: net.IPaddress
    net.ResolveHost(&ip, nil, port)

    server : net.TCPsocket = net.TCP_Open(&ip)
    defer net.TCP_Close(server)
    fmt.println("listening on port", port)

    client : net.TCPsocket 
    defer net.TCP_Close(client)
    // TCP_Accept is non blocking so we need to loop until we get a client
    for client == nil do client = net.TCP_Accept(server) 
    fmt.println("client connected!")
    welcome := "Welcome to Odin echo!\n"
    net.TCP_Send(client, raw_data(welcome), i32(len(welcome)))

    reply : [dynamic]byte
    defer delete(reply)
    r := string(reply[:])
    for {
        append(&reply, "echo: ")
        buf : [128]byte
        length := net.TCP_Recv(client, &buf[0], len(buf))

        if length > 0 {
            msg := string(buf[:length])
            if strings.contains(msg, "bye") {
                fmt.println("saying goodbye!")
                bye := "Good bye!\n"
                net.TCP_Send(client, raw_data(bye), cast(i32)len(bye))
                break
            }
            fmt.print("received:", msg)
            append(&reply, ..buf[:length])
            append(&reply, '\n')
            net.TCP_Send(client, raw_data(reply), cast(i32)len(reply))
            clear(&reply)
        } else do break
    }

    fmt.println("shutting down!")
}