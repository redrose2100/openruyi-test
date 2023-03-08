#define _GNU_SOURCE
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <libaio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(void)
{
    const char *filename;
    char name[1000];
    scanf("%s", name);
    filename = name;

    const char *content = "test libaio";
    io_context_t ctx;
    struct iocb io, *p = &io;
    struct io_event e;
    struct timespec timeout;
    memset(&ctx, 0, sizeof(ctx));
    if (io_setup(10, &ctx) != 0)
    {
        printf("io_setup error\n");
        return 1;
    }

    int fd = open(filename, O_CREAT | O_WRONLY, 0644);
    if (fd == -1)
    {
        io_destroy(ctx);
        return 1;
    }

    io_prep_pwrite(&io, fd, content, strlen(content), 0);
    io.data = content;
    if (io_submit(ctx, 1, &p) != 1)
    {
        io_destroy(ctx);
        printf("io_submit error\n");
        return 1;
    }
    while (1)
    {
        timeout.tv_sec = 0;
        timeout.tv_nsec = 500000000;
        if (io_getevents(ctx, 0, 1, &e, &timeout) == 1)
        {
            close(fd);
            break;
        }
        printf("haven't done\n");
        sleep(1);
    }

    io_destroy(ctx);
    close(fd);

    return 0;
}

