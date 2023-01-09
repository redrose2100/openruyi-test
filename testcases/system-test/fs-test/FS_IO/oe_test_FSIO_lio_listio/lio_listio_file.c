#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <aio.h>
#include <strings.h>
#include <errno.h>

#define BUFFER_SIZE 1024
#define FLAGS O_RDWR | O_APPEND
#define MODE S_IRWXU
#define ERR_EXIT(msg) \
    do                \
    {                 \
        perror(msg);  \
        exit(1);      \
    } while (0)

int main()
{
    struct aiocb *aio_list[3] = {NULL};
    int ret;
    char *filename;
    char name[1000];
    scanf("%s", name);
    filename = name;

    int fd = open(filename, FLAGS, MODE);
    if (fd == -1)
    {
        return 1;
    }

    struct aiocb wr;
    bzero((char *)&wr, sizeof(struct aiocb));
    wr.aio_buf = filename;
    wr.aio_fildes = fd;
    wr.aio_nbytes = 40;
    wr.aio_lio_opcode = LIO_WRITE;
    aio_list[0] = &wr;

    struct aiocb wr1;
    bzero((char *)&wr1, sizeof(struct aiocb));
    wr1.aio_buf = filename;
    wr1.aio_fildes = fd;
    wr1.aio_nbytes = 40;
    wr1.aio_lio_opcode = LIO_WRITE;
    aio_list[1] = &wr1;

    struct aiocb wr2;
    bzero((char *)&wr2, sizeof(struct aiocb));
    wr2.aio_buf = filename;
    wr2.aio_fildes = fd;
    wr2.aio_nbytes = 40;
    wr2.aio_lio_opcode = LIO_WRITE;
    aio_list[2] = &wr2;

    ret = lio_listio(LIO_WAIT, aio_list, 3, NULL);
    close(fd);

    return ret;
}
