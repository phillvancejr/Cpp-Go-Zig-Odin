package main

import "core:fmt"
import "core:math/rand"
import "core:time"

Warrior :: struct {
    name: string,
    hp: i32,
    dmg: i32,
}

attack :: proc(w1, w2: ^Warrior) {
    w2.hp -= w1.dmg
    fmt.printf("%s attacked %s for %d damage!\n", w1.name, w2.name, w1.dmg)
}

display :: proc(w: ^Warrior) {
    fmt.printf("%s hp %d\n", w.name, w.hp)
}

main :: proc() {

    grog := Warrior{ "Grog", 100, 10 }
    bork := Warrior{ "Bork", 100, 10 }

    rand.set_global_seed(cast(u64)time.since(time.Time{0}))

    for grog.hp > 0 && bork.hp > 0{
        i := rand.int31_max(2)
        w1, w2 : ^Warrior
        if i == 0 do w1, w2 = &grog, &bork
        else do w1, w2 = &bork, &grog

        attack(w1, w2)
        fmt.println("")
        display(w1)
        display(w2)
        fmt.println("")
    }

    winner, loser : ^Warrior
    if grog.hp > 0 do winner, loser = &grog, &bork
    else do winner, loser = &bork, &grog

    fmt.printf("%s defeated %s!\n", winner.name, loser.name)
}