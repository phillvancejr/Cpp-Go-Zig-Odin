package main

import "core:fmt"
foreign import add "libadd.a"
foreign add {
    add_five :: proc(num: int) -> int ---
}

main :: proc() {
    fmt.println("result:", add_five(10))
}