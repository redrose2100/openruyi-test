#include <fcntl.h>
#include <string.h>
#include <stdio.h>

int main(void)
{
    const char *filename;
    const char *mode = "w+";
    char name[1000];
    scanf("%s", name);
    filename = name;
    FILE *fp = fopen(filename, mode);
    if (fp == NULL)
    {
        return 1;
    }

    fwrite("test\n", 1, 4, fp);
    fflush(fp);

    int fd = fileno(fp);
    if (fd == -1)
    {
        return 1;
    }

    printf("fd = %d", fd);
    fclose(fp);

    return 0;
}

