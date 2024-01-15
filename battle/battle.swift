class Warrior {
    let name: String
    var hp = 100
    static let dmg = 10
    init(name: String) {
        self.name=name
    }
}

func attack(_ a: Warrior, _ b: Warrior) {
    b.hp -= Warrior.dmg
    print("\(a.name) attacked \(b.name)!")
}

func display(_ w: Warrior) {
    print("\(w.name) hp: \(w.hp)")
}

let grog = Warrior(name: "Grog")
let bork = Warrior(name: "Bork")

while (grog.hp > 0 && bork.hp > 0) {
    let i = Int.random(in: 0...1)
    if (i == 0) {
        attack(grog,bork)
    } else {
        attack(bork,grog)
    }

    print()
    display(grog)
    display(bork)
}

let (winner, loser) = grog.hp > 0 ? (grog,bork) : (bork,grog)
print("\(winner.name) defeated \(loser.name)")