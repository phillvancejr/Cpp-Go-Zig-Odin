// +build ignore
package main
import (
	"fmt"
	"net"
    "bufio"
    "os"
    "io"
    "strings"
)

func main() {
	con, e := net.Dial("tcp", ":8000")

	if e != nil {
		panic(e)
	}
    
    defer con.Close()
    reader := bufio.NewReader(os.Stdin)

    response, e := bufio.NewReader(con).ReadString('\n')
    fmt.Print(string(response))
    for {
        fmt.Printf(">> ");
        msg, _ := reader.ReadString('\n')
        
        _, e = con.Write([]byte(msg))

        if e != nil {
            if e == io.EOF {
                fmt.Println("connection closed")
                break
            }
            fmt.Println(e)
            os.Exit(1)
        }
        
        //go func() {
            //response := make([]byte, 1)
            response, e = bufio.NewReader(con).ReadString('\n')
        
            if e != nil {
                if e == io.EOF {
                    fmt.Println("connection closed")
                    return
                }
                //fmt.Println(e)
                os.Exit(1)
            }
            if strings.Contains(response,"bye") {
                fmt.Println("connection closed")
                os.Exit(0)
            }

            fmt.Print(response)
        //}()
    } 
        
}
