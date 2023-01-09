#include <fcntl.h>
#include <string.h>
#include <stdio.h>

int main(void)
{
    const char *filename;
    const char *mode = "r+";
    char name[1000];
    scanf("%s", name);
    filename = name;
    FILE *fp = fopen(filename, mode);
    if (fp == NULL)
    {
        return 1;
    }
    int isWrite = fwrite("test\n", 1, 1000, fp);
    fclose(fp);
    if (isWrite > 0)
    {
        return 0;
    }

    return 1;
}

