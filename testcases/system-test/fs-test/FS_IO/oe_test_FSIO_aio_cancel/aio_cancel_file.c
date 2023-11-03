#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <assert.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <aio.h>

#define BUFFER_SIZE 1024
#define FLAGS O_RDWR | O_APPEND
#define MODE S_IRWXU

int MAX_LIST = 2;
int main(int argc, char **argv)
{
    struct aiocb rd;
    bzero(&rd, sizeof(rd));
    struct aiocb wr;
    bzero(&wr, sizeof(wr));

    char *filename;
    char name[1000];
    scanf("%s", name);
    filename = name;

    int fd = open(filename, FLAGS, MODE);
    if (fd == -1)
    {
        return 1;
    }

    wr.aio_buf = (char *)malloc(BUFFER_SIZE);
    if (wr.aio_buf == NULL)
    {
        return 1;
    }

    wr.aio_buf = filename;
    wr.aio_fildes = fd;
    wr.aio_nbytes = 1024;

    int ret = aio_write(&wr);
    if (ret < 0)
    {
        return 1;
    }

    if (aio_cancel(fd, &wr) != AIO_NOTCANCELED)
    {
        close(fd);
        return 1;
    }

    ret = aio_return(&wr);
    close(fd);

    return 0;
}

