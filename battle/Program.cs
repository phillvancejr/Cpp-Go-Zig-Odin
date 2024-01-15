using static System.Console;

using Warrior = (string name, int hp);

var grog = (name: "Grog", hp: 100);
var bork = (name: "Bork", hp: 100);

var rng = new Random();

while (grog.hp > 0 && bork.hp > 0) {
    var index = rng.Next(2);

    if (index == 0)
        attack(grog, ref bork);
    else
        attack(bork, ref grog);

    WriteLine("");
    display(grog);
    display(bork);
}

var (winner, loser) = grog.hp > 0 ? (grog,bork) : (bork,grog);

WriteLine($"\n{winner.name} defeated {loser.name}!");

void attack(in Warrior w1, ref Warrior w2) {
        w2.hp -= 10;
        WriteLine($"{w1.name} attacked {w2.name}!");
}

void display(in Warrior w) {
    WriteLine($"{w.name} hp: {w.hp}");
}
