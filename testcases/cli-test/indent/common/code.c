#include <stdio.h>

int main() {
    int num1 = 10;
    int num2 = 20;

    if (num1 > num2) {
        printf("num1 is greater than num2\n");
    } else {
        printf("num2 is greater than num1\n");
    }

    for (int i = 0; i < 5; i++) {
        printf("Iteration %d\n", i);
    }

    return 0;
}
