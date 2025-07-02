#include <stdio.h>

void hello() __attribute__((constructor));

void hello()
{
    printf("Hello from dynamic library!\n");
}
