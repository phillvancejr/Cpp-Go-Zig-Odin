package main
//#cgo darwin LDFLAGS: -L. -ladd
//#include "add.h"
import "C"
import "fmt"

func main() {
	fmt.Printf("result: %d\n", C.add_five(10))
}