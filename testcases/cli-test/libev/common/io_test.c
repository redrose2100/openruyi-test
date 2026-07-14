#include <ev.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

static void io_cb(EV_P_ ev_io *w, int revents) {
    char buf[64];
    ssize_t n = read(w->fd, buf, sizeof(buf) - 1);
    if (n > 0) {
        buf[n] = '\0';
        printf("io read: %s", buf);
        ev_io_stop(EV_A_ w);
        ev_break(EV_A_ EVBREAK_ONE);
    }
}

int main() {
    struct ev_loop *loop = EV_DEFAULT;
    int pipefd[2];
    if (pipe(pipefd) < 0) {
        printf("pipe create failed\n");
        return 1;
    }
    write(pipefd[1], "hello\n", 6);
    close(pipefd[1]);

    ev_io io_watcher;
    ev_io_init(&io_watcher, io_cb, pipefd[0], EV_READ);
    ev_io_start(loop, &io_watcher);
    ev_run(loop, 0);
    close(pipefd[0]);
    printf("io watcher done\n");
    return 0;
}

