#include <libssh/libssh.h>
#include <stdio.h>

int main() {
    ssh_key key = NULL;
    int rc = ssh_pki_generate(SSH_KEYTYPE_ED25519, 0, &key);
    if (rc != SSH_OK) {
        printf("key generate failed\n");
        return 1;
    }
    printf("key generated ok\n");

    enum ssh_keytypes_e ktype = ssh_key_type(key);
    if (ktype != SSH_KEYTYPE_ED25519) {
        printf("key type mismatch\n");
        ssh_key_free(key);
        return 1;
    }
    printf("key type ok\n");

    ssh_key_free(key);
    printf("key freed ok\n");
    return 0;
}
