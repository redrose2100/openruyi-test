#include <fcntl.h>
#include <string.h>
#include <stdio.h>

int main(void)
{
    const char *filename;
    const char *mode = "r";
    char name[1000];
    scanf("%s", name);
    filename = name;
    FILE *fp = fopen(filename, mode);
    if (fp == NULL)
    {
        return 1;
    }

    char str[20] = {0};
    int rFlag = fread(str, 1, 4, fp);
    int wFlag = fwrite("test\n", 1, 4, fp);
    fclose(fp);
    if (rFlag != -1 && rFlag != 0 && (wFlag == -1 || wFlag == 0))
    {
        return 0;
    }

    return 1;
}

