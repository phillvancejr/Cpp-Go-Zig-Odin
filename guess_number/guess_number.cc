#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    srand(time(0));
    auto number = (rand() % 5)+1;

    int guess;
    auto guesses = 1;

    printf("guess 1 - 5: ");
    if ( !scanf("%d", &guess)) guess = -1;

    for ( ; guess != number; guesses++) {
        if( guess < number)
            puts("guess higher!");
        else
            puts("guess lower!");
        if ( !scanf("%d", &guess)) guess = -1;
    }

    printf("you got it in %d tries\n", guesses);
}