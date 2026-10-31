#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-04-27
# @License   :   Mulan PSL v2
# @Desc      : gnupg2 batch keygen, encrypt, decrypt test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# 测试前置准备
function pre_test()
{
    DNF_INSTALL "diffutils"
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL gnupg2

    # 清理旧环境
    rm -rf ~/.gnupg
    rm -rf test.txt test.txt.gpg test_decrypted.txt

    # 生成测试文件
    echo "openEuler GPG test data" > test.txt
    CHECK_RESULT $? 0 0 "Create test.txt failed"
    LOG_INFO "End of environmental preparation!"
}

# 执行测试
function run_test() {
    LOG_INFO "start to run test."

    # 1. 非交互式生成 GPG 密钥
    gpg2 --batch --gen-key <<EOF
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: GPG2 Test User
Name-Email: gpg2-test@example.com
Expire-Date: 1d
Passphrase: testpass123
%no-protection
%commit
EOF
    CHECK_RESULT $? 0 0 "Generate GPG key failed"

    # 2. 验证公钥/私钥存在
    gpg2 --list-keys gpg2-test@example.com
    CHECK_RESULT $? 0 0 "List public keys failed"

    gpg2 --list-secret-keys gpg2-test@example.com
    CHECK_RESULT $? 0 0 "List secret keys failed"

    # 3. 公钥加密
    gpg2 --batch --recipient gpg2-test@example.com --encrypt test.txt
    CHECK_RESULT $? 0 0 "Encrypt file failed"

    # 4. 私钥解密
    gpg2 --batch --passphrase testpass123 --decrypt test.txt.gpg > test_decrypted.txt
    CHECK_RESULT $? 0 0 "Decrypt file failed"

    # 5. 对比原文和解密后内容一致
    diff test.txt test_decrypted.txt
    CHECK_RESULT $? 0 0 "Decrypted file inconsistent"

    LOG_INFO "All test cases executed successfully!"
}

# 清理环境
function post_test()
{
    LOG_INFO "Start to restore the test environment."
    #shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf ~/.gnupg test.txt test.txt.gpg test_decrypted.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
