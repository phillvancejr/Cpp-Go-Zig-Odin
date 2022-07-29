import random,
       strformat

type Warrior = ref object
    name: string
    hp: int
    dmg: int

proc attack(w1: var Warrior, w2: var Warrior) =
    w2.hp -= w1.dmg
    echo fmt"{w1.name} attacked {w2.name} for {w1.dmg} damage!"

proc display(w1: var Warrior) =
    echo fmt"{w1.name} hp {w1.hp}"

randomize()

var
    grog = Warrior(name: "Grog", hp: 100, dmg: 10)
    bork = Warrior(name: "Bork", hp: 100, dmg: 10)

while grog.hp > 0 and bork.hp > 0:
    let i = rand(1)
    var (w1, w2) = if i == 0: (grog , bork)
                   else:      (bork, grog)

    attack(w1,w2)
    echo ""
    display(w1)
    display(w2)
    echo ""

let (winner, loser) = if grog.hp > 0: (grog, bork)
                      else:           (bork, grog)

echo fmt"{winner.name} defeated {loser.name}!"

    