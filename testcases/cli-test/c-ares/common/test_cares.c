#include <sys/select.h>
#include <sys/socket.h>
#include <ares.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>

/* Store the result returned by the asynchronous query callback. */
struct query_state {
    int done;
    int status;
    struct hostent *host;
};

/* Save the asynchronous query result and notify the event loop. */
static void query_callback(void *arg, int status, int timeouts,
                           struct hostent *host)
{
    struct query_state *state = arg;

    (void)timeouts;
    state->done = 1;
    state->status = status;
    state->host = host;
}

int main(void)
{
    ares_channel channel = NULL;
    struct hostent *host = NULL;
    struct query_state state = {0};
    int result = 1;

    /* Initialize the c-ares library and create a query channel. */
    if (ares_library_init(ARES_LIB_INIT_NONE) != ARES_SUCCESS ||
        ares_init(&channel) != ARES_SUCCESS) {
        goto cleanup;
    }

    /* Verify a deterministic basic lookup through the local hosts file. */
    if (ares_gethostbyname_file(channel, "localhost", AF_INET, &host) !=
            ARES_SUCCESS ||
        host == NULL || strcmp(host->h_name, "localhost") != 0) {
        goto cleanup;
    }

    /* Start an asynchronous IPv4 lookup and receive the result by callback. */
    ares_gethostbyname(channel, "localhost", AF_INET, query_callback, &state);
    /* Drive c-ares with select until the callback marks the query complete. */
    while (!state.done) {
        fd_set read_fds;
        fd_set write_fds;
        struct timeval timeout = {5, 0};
        int nfds;

        FD_ZERO(&read_fds);
        FD_ZERO(&write_fds);
        /* Obtain the sockets and timeout currently required by c-ares. */
        nfds = ares_fds(channel, &read_fds, &write_fds);
        ares_timeout(channel, &timeout, &timeout);
        if (select(nfds, &read_fds, &write_fds, NULL, &timeout) < 0) {
            goto cleanup;
        }
        /* Let c-ares process the ready sockets and invoke callbacks. */
        ares_process(channel, &read_fds, &write_fds);
    }

    /* Confirm that the asynchronous callback returned a valid host. */
    if (state.status != ARES_SUCCESS || state.host == NULL) {
        goto cleanup;
    }

    printf("CARES_RESULT basic_dns_and_async_api_ok\n");
    result = 0;

cleanup:
    /* Release resources on both success and failure paths. */
    if (channel != NULL) {
        ares_destroy(channel);
    }
    ares_library_cleanup();
    return result;
}
