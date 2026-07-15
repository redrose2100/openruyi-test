#include <libssh/libssh.h>
#include <stdio.h>

int main() {
    ssh_session session = ssh_new();
    if (session == NULL) {
        printf("session create failed\n");
        return 1;
    }
    printf("session created ok\n");

    int rc;
    const char *host = "localhost";
    unsigned int port = 22;
    const char *user = "testuser";

    rc = ssh_options_set(session, SSH_OPTIONS_HOST, host);
    if (rc != SSH_OK) {
        printf("set host failed\n");
        ssh_free(session);
        return 1;
    }

    rc = ssh_options_set(session, SSH_OPTIONS_PORT, &port);
    if (rc != SSH_OK) {
        printf("set port failed\n");
        ssh_free(session);
        return 1;
    }

    rc = ssh_options_set(session, SSH_OPTIONS_USER, user);
    if (rc != SSH_OK) {
        printf("set user failed\n");
        ssh_free(session);
        return 1;
    }

    printf("session options set ok\n");
    ssh_free(session);
    printf("session freed ok\n");
    return 0;
}
