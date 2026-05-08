#include <openssl/evp.h>
#include <string.h>
#include <stdio.h>

void handleErrors() {
    fprintf(stderr, "An error occurred\n");
    exit(1);
}

void sm4_encrypt_decrypt() {
    // 待加密的明文
    unsigned char plaintext[] = "Hello, SM4 encryption!";
    unsigned char key[16] = "0123456789abcdef"; // 16字节密钥
    unsigned char iv[16] = "abcdef0123456789"; // 16字节初始向量

    // 输出缓冲区
    unsigned char ciphertext[128];
    unsigned char decryptedtext[128];
    int len, ciphertext_len, decryptedtext_len;

    // 创建和初始化加密上下文
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    if (!ctx) handleErrors();

    // 初始化加密操作，使用 SM4-CBC
    if (1 != EVP_EncryptInit_ex(ctx, EVP_sm4_cbc(), NULL, key, iv))
        handleErrors();

    // 执行加密操作
    if (1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, strlen((char *)plaintext)))
        handleErrors();
    ciphertext_len = len;

    // 结束加密操作
    if (1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len))
        handleErrors();
    ciphertext_len += len;

    // 打印加密后的数据
    printf("Ciphertext is:\n");
    for (int i = 0; i < ciphertext_len; i++) {
        printf("%02x ", ciphertext[i]);
    }
    printf("\n");

    // 初始化解密操作
    if (1 != EVP_DecryptInit_ex(ctx, EVP_sm4_cbc(), NULL, key, iv))
        handleErrors();

    // 执行解密操作
    if (1 != EVP_DecryptUpdate(ctx, decryptedtext, &len, ciphertext, ciphertext_len))
        handleErrors();
    decryptedtext_len = len;

    // 结束解密操作
    if (1 != EVP_DecryptFinal_ex(ctx, decryptedtext + len, &len))
        handleErrors();
    decryptedtext_len += len;

    // 打印解密后的明文
    decryptedtext[decryptedtext_len] = '\0'; // 确保字符串以空字符结尾
    printf("Decrypted text is: %s\n", decryptedtext);

    // 清理
    EVP_CIPHER_CTX_free(ctx);
}

int main() {
    sm4_encrypt_decrypt();
    return 0;
}