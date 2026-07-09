
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char *p[100];
    int i;
    for (i = 0; i < 100; i++) {
        p[i] = (char *)malloc(1024);
        if (p[i] == NULL) {
            fprintf(stderr, "malloc failed\n");
            return 1;
        }
        memset(p[i], 'A', 1024);
    }
    for (i = 0; i < 100; i++) {
        free(p[i]);
    }
    printf("tcmalloc basic test passed\n");
    return 0;
}
