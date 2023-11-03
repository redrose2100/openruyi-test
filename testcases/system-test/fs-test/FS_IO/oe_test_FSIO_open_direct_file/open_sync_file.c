#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>

#define FLAGS O_RDWR | O_SYNC
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
    int wFlag = write(fd, name, strlen(name));
    t = clock() - t;

    return ((float)t) / CLOCKS_PER_SEC;
}

