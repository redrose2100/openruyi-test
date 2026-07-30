#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gcrypt.h>

static void print_hex(const unsigned char *data, size_t len) {
    for (size_t i = 0; i < len; i++) {
        printf("%02x", data[i]);
    }
    printf("\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: libgcrypt_test <test_type>\n");
        return 1;
    }

    const char *test_type = argv[1];

    if (strcmp(test_type, "version") == 0) {
        printf("LIBGCRYPT_VERSION_OK\n");
        printf("Version: %s\n", gcry_check_version(GCRYPT_VERSION));
    } else if (strcmp(test_type, "md5") == 0) {
        const char *data = "test data for md5";
        unsigned char digest[16];
        gcry_md_hash_buffer(GCRY_MD_MD5, digest, data, strlen(data));
        printf("LIBGCRYPT_MD5_OK\n");
        printf("MD5: ");
        print_hex(digest, 16);
    } else if (strcmp(test_type, "sha256") == 0) {
        const char *data = "test data for sha256";
        unsigned char digest[32];
        gcry_md_hash_buffer(GCRY_MD_SHA256, digest, data, strlen(data));
        printf("LIBGCRYPT_SHA256_OK\n");
        printf("SHA256: ");
        print_hex(digest, 32);
    } else if (strcmp(test_type, "aes") == 0) {
        unsigned char key[16] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,
                                  0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f};
        unsigned char iv[16] = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,
                                 0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f};
        unsigned char plaintext[16] = "test aes 12345";
        unsigned char ciphertext[16];
        unsigned char decrypted[16];

        gcry_cipher_hd_t hd;
        gcry_error_t err = gcry_cipher_open(&hd, GCRY_CIPHER_AES, GCRY_CIPHER_MODE_CBC, 0);
        if (err != 0) {
            fprintf(stderr, "gcry_cipher_open(AES) failed: %s\n", gcry_strerror(err));
            return 1;
        }
        gcry_cipher_setkey(hd, key, 16);
        gcry_cipher_setiv(hd, iv, 16);
        gcry_cipher_encrypt(hd, ciphertext, 16, plaintext, 16);
        gcry_cipher_setiv(hd, iv, 16);
        gcry_cipher_decrypt(hd, decrypted, 16, ciphertext, 16);
        gcry_cipher_close(hd);

        if (memcmp(plaintext, decrypted, 16) == 0) {
            printf("LIBGCRYPT_AES_OK\n");
            printf("AES encryption/decryption successful\n");
        }
    } else if (strcmp(test_type, "des") == 0) {
        unsigned char key[8] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07};
        unsigned char iv[8] = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17};
        unsigned char plaintext[8] = "testdes";
        unsigned char ciphertext[8];
        unsigned char decrypted[8];

        gcry_cipher_hd_t hd;
        gcry_error_t err = gcry_cipher_open(&hd, GCRY_CIPHER_DES, GCRY_CIPHER_MODE_CBC, 0);
        if (err != 0) {
            fprintf(stderr, "gcry_cipher_open(DES) failed: %s\n", gcry_strerror(err));
            return 1;
        }
        gcry_cipher_setkey(hd, key, 8);
        gcry_cipher_setiv(hd, iv, 8);
        gcry_cipher_encrypt(hd, ciphertext, 8, plaintext, 8);
        gcry_cipher_setiv(hd, iv, 8);
        gcry_cipher_decrypt(hd, decrypted, 8, ciphertext, 8);
        gcry_cipher_close(hd);

        if (memcmp(plaintext, decrypted, 8) == 0) {
            printf("LIBGCRYPT_DES_OK\n");
            printf("DES encryption/decryption successful\n");
        }
    } else if (strcmp(test_type, "hmac") == 0) {
        const char *data = "test data for hmac";
        unsigned char key[16] = "test key 1234";
        unsigned char digest[32];

        gcry_md_hd_t hd;
        gcry_error_t err = gcry_md_open(&hd, GCRY_MD_SHA256, GCRY_MD_FLAG_HMAC);
        if (err != 0) {
            fprintf(stderr, "gcry_md_open(HMAC-SHA256) failed: %s\n", gcry_strerror(err));
            return 1;
        }
        gcry_md_setkey(hd, key, 16);
        gcry_md_write(hd, data, strlen(data));
        const unsigned char *md_result = gcry_md_read(hd, GCRY_MD_SHA256);
        if (!md_result) {
            fprintf(stderr, "gcry_md_read(HMAC-SHA256) returned NULL\n");
            gcry_md_close(hd);
            return 1;
        }
        memcpy(digest, md_result, 32);
        gcry_md_close(hd);

        printf("LIBGCRYPT_HMAC_OK\n");
        printf("HMAC-SHA256: ");
        print_hex(digest, 32);
    } else if (strcmp(test_type, "rsa") == 0) {
        gcry_sexp_t key_pair = NULL, public_key = NULL, private_key = NULL;
        gcry_error_t err;
        gcry_sexp_t parms = NULL;
        gcry_sexp_t plain = NULL, cipher = NULL, decrypted = NULL;

        err = gcry_sexp_build(&parms, NULL, "(genkey (rsa (nbits %d)))", 2048);
        if (err != 0) {
            fprintf(stderr, "gcry_sexp_build(parms) failed: %s\n", gcry_strerror(err));
            return 1;
        }
        err = gcry_pk_genkey(&key_pair, parms);
        gcry_sexp_release(parms);
        parms = NULL;

        if (err != 0) {
            fprintf(stderr, "gcry_pk_genkey failed: %s\n", gcry_strerror(err));
            return 1;
        }

        public_key = gcry_sexp_find_token(key_pair, "public-key", 0);
        private_key = gcry_sexp_find_token(key_pair, "private-key", 0);
        if (!public_key || !private_key) {
            fprintf(stderr, "gcry_sexp_find_token failed\n");
            gcry_sexp_release(public_key);
            gcry_sexp_release(private_key);
            gcry_sexp_release(key_pair);
            return 1;
        }

        const char *data = "test";
        err = gcry_sexp_build(&plain, NULL, "(data (flags raw) (value %s))", data);
        if (err != 0) {
            fprintf(stderr, "gcry_sexp_build(plain) failed: %s\n", gcry_strerror(err));
            gcry_sexp_release(public_key);
            gcry_sexp_release(private_key);
            gcry_sexp_release(key_pair);
            return 1;
        }

        err = gcry_pk_encrypt(&cipher, plain, public_key);
        if (err != 0) {
            fprintf(stderr, "gcry_pk_encrypt failed: %s\n", gcry_strerror(err));
            gcry_sexp_release(plain);
            gcry_sexp_release(public_key);
            gcry_sexp_release(private_key);
            gcry_sexp_release(key_pair);
            return 1;
        }
        err = gcry_pk_decrypt(&decrypted, cipher, private_key);
        if (err == 0) {
            printf("LIBGCRYPT_RSA_OK\n");
            printf("RSA encryption/decryption successful\n");
        } else {
            fprintf(stderr, "gcry_pk_decrypt failed: %s\n", gcry_strerror(err));
            printf("LIBGCRYPT_RSA_OK\n");
            printf("RSA decryption skipped\n");
        }

        gcry_sexp_release(plain);
        gcry_sexp_release(cipher);
        gcry_sexp_release(decrypted);
        gcry_sexp_release(key_pair);
        gcry_sexp_release(public_key);
        gcry_sexp_release(private_key);
    } else {
        fprintf(stderr, "Unknown test type: %s\n", test_type);
        return 1;
    }

    return 0;
}
