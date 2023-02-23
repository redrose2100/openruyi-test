#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>

int main(void)
{
    const char *filename;
    const char *mode = "a+";
    char name[1000];
    scanf("%s", name);
    filename = name;

    int tr = truncate(filename, 20);
    if (tr != 0)
    {
        return 1;
    }
    FILE *fp = fopen(filename, "r");
    if (fp == NULL)
    {
        return 1;
    }

    char buffer[20];
    memset(buffer, 0, sizeof(buffer));
    int readbytes = fread(buffer, 1, 50, fp);
    if (readbytes != 20)
    {
        return 1;
    }

    fclose(fp);

    return 0;
}

