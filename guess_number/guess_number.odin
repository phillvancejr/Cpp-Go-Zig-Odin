
package main

import "core:fmt"
import "core:math/rand"
import "core:time"
import "core:bufio"
import "core:io"
import "core:os"
import "core:strconv"

main :: proc() {
    rand.set_global_seed(u64(time.since(time.Time{0})))
	number := rand.int_max(5)+1
    // setup reader
    stdin := os.stream_from_handle(os.stdin)
    reader: bufio.Reader
    bufio.reader_init(&reader, io.Reader{stdin})

	guesses := 1

	fmt.print("guess 1-5: ")
    guess := read_num(&reader)

	for ; guess != number; guesses += 1 {
        if guess < number do fmt.println("guess higher!")
		else do fmt.println("guess lower!")
        guess = read_num(&reader)
    }

    fmt.printf("you got it in %d tries\n", guesses);
}
// parse_int returns (value: int, ok: bool)
// here I use or_return to return -1 if the conversion doesn't work
read_num :: proc(reader: ^bufio.Reader ) -> int {
    line, _ := bufio.reader_read_string(reader, '\n')
    return strconv.parse_int(string(line[:1])) or_else -1    
}