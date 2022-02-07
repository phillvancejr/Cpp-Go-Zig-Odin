package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	number := rand.Intn(5) + 1

	var guess int
	guesses := 1

	fmt.Printf("guess 1-5: ")
	_, e := fmt.Scanf("%d", &guess)
	if e != nil {
		guess = -1
	}

	for ; guess != number; guesses += 1 {
		if guess < number {
			fmt.Println("guess higher!")
		} else {
			fmt.Println("guess lower!")
		}

		_, e = fmt.Scanf("%d", &guess)

		if e != nil {
			guess = -1
		}
	}

	fmt.Printf("you got it in %d tries\n", guesses)
}
