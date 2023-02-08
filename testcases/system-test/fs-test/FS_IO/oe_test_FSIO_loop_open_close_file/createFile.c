#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

#define FLAGS O_WRONLY | O_CREAT | O_TRUNC
#define MODE S_IRWXU | S_IXGRP | S_IROTH | S_IXOTH

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
    write(fd, name, strlen(name));
    printf("fd = %d", fd);
    close(fd);

    return 0;
}

