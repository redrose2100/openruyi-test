#include <stdio.h>
#include "math.h"
int main()
{
        int a, b;
        printf("Please input a and b:\n");
        scanf("%d %d", &a, &b);
        printf("The add: %d\n", add(a,b));
        printf("The sub: %d\n", sub(a,b));
        return 0;
}

