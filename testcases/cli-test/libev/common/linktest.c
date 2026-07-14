#include <ev.h>
#include <stdio.h>

int main() {
    struct ev_loop *loop = ev_default_loop(0);
    if (loop == NULL) {
        printf("loop init failed\n");
        return 1;
    }
    printf("libev link ok\n");
    ev_loop_destroy(loop);
    return 0;
}
