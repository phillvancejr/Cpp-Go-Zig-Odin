import  asyncnet,
        asyncdispatch,
        strutils

proc serve() {.async.} =
    let server = new_async_socket()
    defer: server.close()
    server.set_sock_opt(OptReusePort,true)
    server.bind_addr(Port(8000))
    server.listen()
    echo "Listening on Port 8000"

    let client = await server.accept()
    defer: client.close()
    echo "Client Connected!"
    await client.send("Welcome!\n")

    while not client.is_closed():
        let msg = await client.recv_line()
        if msg.is_empty_or_whitespace():
            echo "client disconnected"
            break
        elif msg.starts_with("bye"):
            echo "saying goodbye"
            await client.send("Bye!\n")
            break
        let reply = "echo: " & msg & "\n"
        await client.send(reply)
        stdout.write(reply)

#discard serve()
#run_forever()
wait_for(serve())
