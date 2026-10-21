#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char *p[50];
    int i;
    for (i = 0; i < 50; i++) {
        p[i] = (char *)malloc(1024 * 1024);
        if (p[i] == NULL) {
            fprintf(stderr, "malloc failed\n");
            return 1;
        }
        memset(p[i], 'B', 1024 * 1024);
    }
    for (i = 0; i < 50; i++) {
        free(p[i]);
    }
    printf("Heap profiler test completed\n");
    return 0;
}
