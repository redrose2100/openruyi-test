#include <stdio.h>

#define BUF_LEN (8 * 1024 * 1024)

int main(void)
{
    int cnt = 0;
    char *p = NULL;
    unsigned int total = 0;
    while (1)
    {
        cnt++;
        p = (char *)malloc(BUF_LEN);
        if (p == NULL)
        {
            printf("[%d]malloc for %d failed.\n", cnt, BUF_LEN);
            break;
        }
        total += BUF_LEN;
        printf("[%d]malloc %p ok total: %u(%.1fKB %.1fMB)\n", cnt, p, total, total / 1024.0, total / 1024.0 / 1024.0);
    }

    return 0;
}
