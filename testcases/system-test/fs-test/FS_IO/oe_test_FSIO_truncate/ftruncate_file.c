#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

#define FLAGS O_RDWR
#define MODE S_IRWXU

int main(void)
{
    const char *filename;
    char name[1000];
    scanf("%s", name);
    filename = name;

    int fd = open(filename, FLAGS, MODE);
    if (fd == -1)
    {
        return 1;
    }

    int ft = ftruncate(fd, 20);
    if (ft != 0)
    {
        return 1;
    }

    char str[20] = {0};
    int readbytes = read(fd, str, 50);
    if (readbytes != 20)
    {
        return 1;
    }

    close(fd);

    return 0;
}

