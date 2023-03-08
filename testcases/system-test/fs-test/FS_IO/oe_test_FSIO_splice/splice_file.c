#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    int pipefd[2];
    int result = pipe(pipefd);
    FILE *inf;
    FILE *outf;

    if (argc != 3)
    {
        return 1;
    }

    inf = fopen(argv[1], "r+");
    outf = fopen(argv[2], "w+");

    off_t off_in = 0, off_out = 0;

    int size = 65536;
    splice(fileno(inf), &off_in, pipefd[1], NULL, size, SPLICE_F_MORE | SPLICE_F_MOVE);
    splice(pipefd[0], NULL, fileno(outf), &off_out, size, SPLICE_F_MORE | SPLICE_F_MOVE);

    close(pipefd[0]);
    close(pipefd[1]);
    fclose(inf);
    fclose(outf);

    return 0;
}

