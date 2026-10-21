#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char *p = (char *)malloc(1024);
    if (p == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    memset(p, 'D', 1024);
    free(p);
    printf("No leak test completed\n");
    return 0;
}
