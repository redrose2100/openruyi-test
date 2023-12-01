#define _GNU_SOURCE
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <aio.h>

#define BUFFER_SIZE 1024
#define FLAGS O_RDONLY
#define MODE S_IRWXU

int MAX_LIST = 2;

int main(int argc, char **argv)
{
    struct aiocb rd;
    const char *filename;
    char name[1000];
    scanf("%s", name);
    filename = name;

    int fd = open(filename, FLAGS, MODE);
    if (fd == -1)
    {
        return 1;
    }

    bzero(&rd, sizeof(rd));
    rd.aio_buf = malloc(BUFFER_SIZE + 1);
    rd.aio_fildes = fd;
    rd.aio_nbytes = BUFFER_SIZE;
    rd.aio_offset = 0;

    int ret = aio_read(&rd);
    if (ret < 0)
    {
        return 1;
    }

    int couter = 0;
    while (aio_error(&rd) == EINPROGRESS)
    {
        ++couter;
    }
    ret = aio_return(&rd);
    printf("%d", ret);
    close(fd);

    return 0;
}
