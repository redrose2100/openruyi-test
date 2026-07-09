#include <stdio.h>
#include <stdlib.h>
#include <string.h>

volatile double g_sum = 0;

void cpu_heavy() {
    int i, j;
    double sum = 0;
    for (i = 0; i < 50000000; i++) {
        for (j = 0; j < 10; j++) {
            sum += i * j;
        }
    }
    g_sum = sum;
}

int main() {
    char *p[20];
    int i;
    cpu_heavy();
    for (i = 0; i < 20; i++) {
        p[i] = (char *)malloc(1024 * 512);
        if (p[i] == NULL) {
            fprintf(stderr, "malloc failed\n");
            return 1;
        }
        memset(p[i], 'F', 1024 * 512);
    }
    for (i = 0; i < 20; i++) {
        free(p[i]);
    }
    cpu_heavy();
    printf("Environment test completed\n");
    return 0;
}
