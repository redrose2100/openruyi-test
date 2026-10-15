#include <ev.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>

static void sig_cb(EV_P_ ev_signal *w, int revents) {
    printf("signal received\n");
    ev_signal_stop(EV_A_ w);
    ev_break(EV_A_ EVBREAK_ONE);
}

int main() {
    struct ev_loop *loop = EV_DEFAULT;
    ev_signal sig_watcher;
    ev_signal_init(&sig_watcher, sig_cb, SIGUSR1);
    ev_signal_start(loop, &sig_watcher);
    kill(getpid(), SIGUSR1);
    ev_run(loop, 0);
    printf("signal watcher done\n");
    return 0;
}
