#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2024.8.16
# @License   :   Mulan PSL v2
# @Desc      :   libtomcrypt formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/libtomcrypt_test.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <tomcrypt.h>

int main() {
    int ret;
    unsigned char key[16] = "0123456789abcdef";
    unsigned char plaintext[16] = "Hello, World!";
    unsigned char ciphertext[16];
    symmetric_key symkey;

    // 初始化libtomcrypt
    if (register_cipher(&aes_desc) == -1) {
        fprintf(stderr, "无法注册AES算法\n");
        exit(EXIT_FAILURE);
    }

    // 加密
    ret = aes_setup(key, 16, 0, &symkey);
    if (ret != CRYPT_OK) {
        fprintf(stderr, "无法设置AES密钥: %s\n", error_to_string(ret));
        exit(EXIT_FAILURE);
    }

    ret = aes_ecb_encrypt(plaintext, ciphertext, &symkey);
    if (ret != CRYPT_OK) {
        fprintf(stderr, "无法加密: %s\n", error_to_string(ret));
        exit(EXIT_FAILURE);
    }

    // 打印密文
    printf("密文: ");
    for (int i = 0; i < 16; i++) {
        printf("%02x", ciphertext[i]);
    }
    printf("\n");

    // 解密
    ret = aes_ecb_decrypt(ciphertext, plaintext, &symkey);
    if (ret != CRYPT_OK) {
        fprintf(stderr, "无法解密: %s\n", error_to_string(ret));
        exit(EXIT_FAILURE);
    }

    // 打印明文
    printf("明文: %s\n", plaintext);

    // 清理资源
    aes_done(&symkey);
    unregister_cipher(&aes_desc);

    return 0;
}

EOF

    DNF_INSTALL "libtomcrypt*"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libtomcrypt
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc -o libtomcrypt_test libtomcrypt_test.c -ltomcrypt
    test -f /tmp/libtomcrypt_test
    CHECK_RESULT $? 0 0 "libtomcrypt test fail"
    cd /tmp && ./libtomcrypt_test > test_file
    grep "Hello, World!" /tmp/test_file   
    CHECK_RESULT $? 0 0 "execute libtomcrypt_test fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/libtomcrypt_test /tmp/test_file /tmp/libtomcrypt_test.c
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
