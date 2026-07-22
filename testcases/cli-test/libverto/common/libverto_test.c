#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/socket.h>
#include <verto.h>

static int timer_fired = 0;
static int fd_event_fired = 0;

static void timer_callback(verto_ctx *ctx, verto_ev *ev)
{
    timer_fired = 1;
    verto_break(ctx);
}

static void fd_read_callback(verto_ctx *ctx, verto_ev *ev)
{
    char buf[1024];
    int fd = verto_get_fd(ev);
    ssize_t n = read(fd, buf, sizeof(buf));
    if (n > 0) {
        fd_event_fired = 1;
        verto_break(ctx);
    }
}

int main(int argc, char *argv[])
{
    verto_ctx *ctx;
    verto_ev *ev;
    int sockfd[2];
    const char *msg = "test";
    const char *backend = NULL;

    if (argc > 1) {
        backend = argv[1];
    }

    if (backend && strcmp(backend, "libev") == 0) {
        printf("VERTO_LIBEV_BACKEND_SELECTED\n");
    } else if (backend && strcmp(backend, "libevent") == 0) {
        printf("VERTO_LIBEVENT_BACKEND_SELECTED\n");
    } else {
        printf("VERTO_DEFAULT_BACKEND_SELECTED\n");
    }

    ctx = verto_new(backend, 0);
    if (!ctx) {
        printf("VERTO_CTX_CREATE_FAIL\n");
        return 1;
    }

    ev = verto_add_timeout(ctx, VERTO_EV_FLAG_NONE, timer_callback, 100);
    if (!ev) {
        printf("VERTO_TIMER_ADD_FAIL\n");
        verto_free(ctx);
        return 1;
    }
    verto_run(ctx);
    verto_free(ctx);

    if (timer_fired) {
        printf("VERTO_TIMER_OK\n");
    } else {
        printf("VERTO_TIMER_NOT_FIRED\n");
        return 1;
    }

    ctx = verto_new(backend, 0);
    if (!ctx) {
        printf("VERTO_CTX_CREATE_FAIL\n");
        return 1;
    }

    if (socketpair(AF_UNIX, SOCK_STREAM, 0, sockfd) != 0) {
        printf("VERTO_SOCKETPAIR_FAIL\n");
        verto_free(ctx);
        return 1;
    }

    ev = verto_add_io(ctx, VERTO_EV_FLAG_IO_READ, fd_read_callback, sockfd[0]);
    if (!ev) {
        printf("VERTO_FD_ADD_FAIL\n");
        close(sockfd[0]);
        close(sockfd[1]);
        verto_free(ctx);
        return 1;
    }

    ssize_t wn = write(sockfd[1], msg, strlen(msg));
    if (wn != strlen(msg)) {
        printf("VERTO_WRITE_FAIL\n");
        close(sockfd[0]);
        close(sockfd[1]);
        verto_free(ctx);
        return 1;
    }
    verto_run(ctx);
    close(sockfd[0]);
    close(sockfd[1]);
    verto_free(ctx);

    if (fd_event_fired) {
        printf("VERTO_FD_EVENT_OK\n");
    } else {
        printf("VERTO_FD_EVENT_NOT_FIRED\n");
        return 1;
    }

    if (backend && strcmp(backend, "libev") == 0) {
        printf("VERTO_LIBEV_ALL_PASS\n");
    } else if (backend && strcmp(backend, "libevent") == 0) {
        printf("VERTO_LIBEVENT_ALL_PASS\n");
    } else {
        printf("VERTO_DEFAULT_ALL_PASS\n");
    }

    return 0;
}

