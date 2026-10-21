#include <ev.h>
#include <stdio.h>

static void timer_cb(EV_P_ ev_timer *w, int revents) {
    printf("timer fired\n");
    ev_break(EV_A_ EVBREAK_ONE);
}

int main() {
    struct ev_loop *loop = EV_DEFAULT;
    ev_timer timer_watcher;
    ev_timer_init(&timer_watcher, timer_cb, 0.3, 0.);
    ev_timer_start(loop, &timer_watcher);
    ev_run(loop, 0);
    printf("timer loop ended\n");
    return 0;
}

