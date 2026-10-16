#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

int fd;
#define MAX 255
#define filename "test_prw_file"
void *r_thread(void *p)
{
    int i = 0, j = 0;
    for (i = 0; i < MAX; i++)
    {
        usleep(100);
        pread(fd, &j, 1, i);
        printf("%s: %d\n", __FUNCTION__, j);
    }

    return NULL;
}

void *w_thread(void *p)
{
    int i = 0, j = 0;
    for (i = 0; i < MAX; i++)
    {
        usleep(100);
        pwrite(fd, &i, 1, i);
        printf("%s: %d\n", __FUNCTION__, i);
    }

    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t ppid;

    fd = open(filename, O_RDWR | O_APPEND, 0777);
    pthread_create(&ppid, NULL, r_thread, NULL);
    pthread_create(&ppid, NULL, w_thread, NULL);
    getchar();
    close(fd);
    return 0;
}
