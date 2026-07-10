#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char *p = (char *)malloc(1024);
    if (p == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    memset(p, 'C', 1024);
    /* Intentionally not freeing p to test leak detection */
    printf("Memory leak test completed\n");
    return 0;
}
