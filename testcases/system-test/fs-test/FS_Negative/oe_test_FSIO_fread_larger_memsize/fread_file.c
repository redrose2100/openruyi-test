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
    char str[214986] = {0};
    int isRead = fread(str, sizeof(str), 1, fp);
    fclose(fp);
    if (isRead > 0 && str > 0)
    {
        return 1;
    }

    return 0;
}

