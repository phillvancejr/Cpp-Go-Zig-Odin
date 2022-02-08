package main

import (
	"fmt"
	"net"
    "strings"
)

func main() {
	server, e := net.Listen("tcp", ":8000")

	if e != nil {
		panic(e)
	}

	defer server.Close()


	fmt.Println("Listening on port 8000")
    
    client, e := server.Accept()
    if e != nil {
        panic(e)
    }
    fmt.Println("Client Connected!")
	for {

		buf := make([]byte, 1024)

		_, e = client.Read(buf)
		if e != nil {
			panic(e)
		}

		if strings.HasPrefix(string(buf), "bye") {
            fmt.Println("saying goodbye!")
			client.Write([]byte("Bye!\n"))
			client.Close()
			break
		}
        reply := []byte("echo: ")
        reply = append(reply, buf...)
        reply = append(reply, '\n')
        client.Write(reply)
        fmt.Println(string(buf))
	}

	fmt.Println("shutting down")
}
