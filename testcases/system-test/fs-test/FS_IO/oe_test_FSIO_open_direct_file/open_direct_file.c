#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>

#define FLAGS O_RDWR | O_DIRECT
#define MODE S_IRWXU

int main(void)
{
    const char *filename;
    int fd;
    char name[1000];
    scanf("%s", name);
    filename = name;

    clock_t t = clock();
    if ((fd = open(filename, FLAGS, MODE)) == -1)
    {
        return 1;
    }

    char str[20] = {0};
    int rFlag = read(fd, str, 20);
    const int size = 4096 * 10;
    char *p = malloc(size + 512);
    int wFlag = write(fd, p, size);
    t = clock() - t;
    close(fd);

    return ((float)t) / CLOCKS_PER_SEC;
}

