package main

import (
	"fmt"
	"math/rand"
	"time"
)

type Warrior struct {
	name string
	hp   int
	dmg  int
}

func attack(w1, w2 *Warrior) {
	w2.hp -= w1.dmg
	fmt.Printf("%s attacked %s for %d damage!\n", w1.name, w2.name, w1.dmg)
}

func display(w *Warrior) {
	fmt.Printf("%s hp %d\n", w.name, w.hp)
}

func main() {
	grog := Warrior{"Grog", 100, 10}
	bork := Warrior{"Bork", 100, 10}

	warriors := []*Warrior{&grog, &bork}

	rand.Seed(time.Now().UnixNano())

	for grog.hp > 0 && bork.hp > 0 {
		i := rand.Intn(2)

		var w1, w2 *Warrior

		w1 = warriors[i]
		w2 = warriors[(i+1)%2]

		attack(w1, w2)
		fmt.Println("")
		display(w1)
		display(w2)
		fmt.Println("")
	}

	var winner, loser *Warrior
	i := 0
	if grog.hp <= 0 {
		i = 1
	}

	winner = warriors[i]
	loser = warriors[(i+1)%2]

	fmt.Printf("%s defeated %s!\n", winner.name, loser.name)

}
