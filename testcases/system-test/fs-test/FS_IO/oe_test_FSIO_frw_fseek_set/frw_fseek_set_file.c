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
    int ret = fseek(fp, 0, SEEK_SET);

    char str[20] = {0};
    int isRead = fread(str, 1, 4, fp);
    int isWrite = fwrite("test\n", 1, 4, fp);
    fclose(fp);

    if (ret == -1 || isRead == 0 || isRead == -1 || isWrite != 4)
    {
        return 1;
    }

    return 0;
}

