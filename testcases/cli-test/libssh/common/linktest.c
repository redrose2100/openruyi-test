#include <libssh/libssh.h>
#include <stdio.h>

int main() {
    int rc = ssh_init();
    if (rc != SSH_OK) {
        printf("libssh init failed\n");
        return 1;
    }
    printf("libssh link ok\n");
    ssh_finalize();
    return 0;
}

