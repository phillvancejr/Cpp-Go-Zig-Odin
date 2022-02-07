#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string>

using namespace std;
struct Warrior {
	string name;
	int hp;
	int dmg;
};

auto attack(Warrior* w1, Warrior* w2) 
{
	w2->hp -= w1->dmg;
    printf("%s attacked %s for %d damage!\n", w1->name.c_str(), w2->name.c_str(), w1->dmg);
}

auto display(Warrior* w) 
{
    printf("%s hp %d\n", w->name.c_str(), w->hp);
}

int main() {
    Warrior grog{"Grog", 100, 10};
    Warrior bork{"Bork", 100, 10};

    Warrior* warriors[2]{ &grog, &bork };
    srand(time(0));

    while ( grog.hp > 0 and bork.hp > 0  )
    {
        auto i = rand() % 2;
        auto w1 = warriors[i];
        auto w2 = warriors[++i%2];

        attack(w1, w2);
        puts("");
        display(w1);
        display(w2);
        puts("");
    }

    auto i = grog.hp > 0 ? 0 : 1;

	auto winner = warriors[i];
	auto loser = warriors[++i%2];

    printf("%s defeated %s!\n", winner->name.c_str(), loser->name.c_str());

}