#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

#define FLAGS O_RDWR
#define MODE S_IRWXU

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
    int offset = lseek(fd, 0, SEEK_SET);
    int rFlag = read(fd, str, 20);
    int wFlag = write(fd, name, strlen(name));
    close(fd);

    printf("offset = %d\n", offset);
    printf("readset = %d\n", rFlag);
    printf("writeset = %d\n", wFlag);
}

