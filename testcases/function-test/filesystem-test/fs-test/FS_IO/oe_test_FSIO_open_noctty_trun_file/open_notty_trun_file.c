#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

#define FLAGS O_RDWR | O_TRUNC | O_NOCTTY
#define MODE S_IRWXU | S_IRGRP | S_IROTH

int main(void)
{
    const char *filename;
    int fd;
    char name[1000];
    scanf("%s", name);
    filename = name;
    if ((fd = open(filename, FLAGS, MODE)) == -1)
    {
        return 1;
    }

    char str[20] = {0};
    int rFlag = read(fd, str, 20);
    int wFlag = write(fd, name, strlen(name));

    if (rFlag != -1 && wFlag != -1)
    {
        return 0;
    }
    close(fd);

    return 1;
}

