/*
 * Test program for c-ares async DNS query API.
 * Usage: c-ares_test <hostname>
 * Performs an asynchronous host name lookup using the full c-ares event
 * loop (ares_library_init -> ares_init -> ares_gethostbyname ->
 * ares_process -> ares_destroy -> ares_library_cleanup) and prints the
 * resolved IP addresses to stdout.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/select.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <ares.h>

static const char *g_hostname;

static void host_callback(void *arg, int status, int timeouts,
                          struct hostent *hostent)
{
    (void)arg;
    (void)timeouts;

    if (status != ARES_SUCCESS) {
        fprintf(stderr, "ares_gethostbyname failed: %s\n", ares_strerror(status));
        return;
    }

    if (hostent == NULL || hostent->h_addr_list == NULL) {
        fprintf(stderr, "no address returned\n");
        return;
    }

    char addr_buf[INET6_ADDRSTRLEN];
    for (char **addr = hostent->h_addr_list; *addr != NULL; addr++) {
        if (inet_ntop(hostent->h_addrtype, *addr, addr_buf, sizeof(addr_buf)) != NULL) {
            printf("%s\n", addr_buf);
        }
    }
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s <hostname>\n", argv[0]);
        return 1;
    }
    g_hostname = argv[1];

    int rc = ares_library_init(ARES_LIB_INIT_ALL);
    if (rc != ARES_SUCCESS) {
        fprintf(stderr, "ares_library_init failed: %s\n", ares_strerror(rc));
        return 1;
    }

    ares_channel channel;
    rc = ares_init(&channel);
    if (rc != ARES_SUCCESS) {
        fprintf(stderr, "ares_init failed: %s\n", ares_strerror(rc));
        ares_library_cleanup();
        return 1;
    }

    /* Fire an async A record lookup for the requested hostname. */
    ares_gethostbyname(channel, g_hostname, AF_INET, host_callback, NULL);

    /* Drive the async event loop until no more work is pending. */
    for (;;) {
        fd_set read_fds;
        fd_set write_fds;
        FD_ZERO(&read_fds);
        FD_ZERO(&write_fds);

        int nfds = ares_fds(channel, &read_fds, &write_fds);
        if (nfds == 0) {
            break;
        }

        struct timeval tv;
        struct timeval *tvp = ares_timeout(channel, NULL, &tv);
        if (tvp == NULL) {
            break;
        }

        int ready = select(nfds, &read_fds, &write_fds, NULL, tvp);
        if (ready < 0) {
            perror("select");
            break;
        }

        ares_process(channel, &read_fds, &write_fds);
    }

    ares_destroy(channel);
    ares_library_cleanup();
    return 0;
}
