#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/27
# @License   :   Mulan PSL v2
# @Desc      :   Verify libgcrypt package and basic encryption functions
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libgcrypt-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q libgcrypt | grep "libgcrypt"
    CHECK_RESULT $? 0 0 "libgcrypt package not installed"
    rpm -V libgcrypt
    CHECK_RESULT $? 0 0 "libgcrypt package verification failed"
    test -f /usr/include/gcrypt.h
    CHECK_RESULT $? 0 0 "libgcrypt header file gcrypt.h missing"
    rpm -ql libgcrypt | grep -E "\.(so|so\.[0-9]+)$"
    CHECK_RESULT $? 0 0 "libgcrypt shared library missing"
    g++ -std=c++11 "./common/libgcrypt_test.c" -o "./libgcrypt_test" -lgcrypt
    CHECK_RESULT $? 0 0 "Failed to compile libgcrypt test program"
    ./libgcrypt_test version | grep "LIBGCRYPT_VERSION_OK"
    CHECK_RESULT $? 0 0 "libgcrypt version test failed"
    ./libgcrypt_test md5 | grep "LIBGCRYPT_MD5_OK"
    CHECK_RESULT $? 0 0 "libgcrypt MD5 hash test failed"
    ./libgcrypt_test sha256 | grep "LIBGCRYPT_SHA256_OK"
    CHECK_RESULT $? 0 0 "libgcrypt SHA256 hash test failed"
    ./libgcrypt_test aes | grep "LIBGCRYPT_AES_OK"
    CHECK_RESULT $? 0 0 "libgcrypt AES encryption test failed"
    ./libgcrypt_test des | grep "LIBGCRYPT_DES_OK"
    CHECK_RESULT $? 0 0 "libgcrypt DES encryption test failed"
    ./libgcrypt_test hmac | grep "LIBGCRYPT_HMAC_OK"
    CHECK_RESULT $? 0 0 "libgcrypt HMAC test failed"
    ./libgcrypt_test rsa | grep "LIBGCRYPT_RSA_OK"
    CHECK_RESULT $? 0 0 "libgcrypt RSA test failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -f ./libgcrypt_test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
