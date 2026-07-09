#include <stdio.h>
#include <stdlib.h>
#include <string.h>

volatile double g_sum_a = 0;
volatile double g_sum_b = 0;

void func_a() {
    int i;
    double sum = 0;
    for (i = 0; i < 50000000; i++) {
        sum += i;
    }
    g_sum_a = sum;
}

void func_b() {
    int i;
    char *p[100];
    double sum = 0;
    for (i = 0; i < 100; i++) {
        p[i] = (char *)malloc(1024);
        memset(p[i], 'E', 1024);
        sum += i;
    }
    for (i = 0; i < 100; i++) {
        free(p[i]);
    }
    g_sum_b = sum;
}

int main() {
    func_a();
    func_b();
    func_a();
    printf("pprof test completed\n");
    return 0;
}
