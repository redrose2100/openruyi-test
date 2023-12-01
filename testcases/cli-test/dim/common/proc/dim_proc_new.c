#include <stdio.h>
#include <unistd.h>
#define TIMER_INTERVAL 10000000

int main(int argc, char *argv[])
{
    printf("hello\n");
    sleep(TIMER_INTERVAL);
    return 0;
}

