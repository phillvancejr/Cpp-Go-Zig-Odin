#include <stdio.h>
extern "C" int add_five(int);
int main() {
    printf("result: %d\n", add_five(10));
}