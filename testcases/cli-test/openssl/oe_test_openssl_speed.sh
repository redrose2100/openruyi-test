#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-4-6
# @License   :   Mulan PSL v2
# @Desc      :   Command openssl speed
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    openssl speed -elapsed rsa512 > openssl.log
    grep "rsa  512 bits" openssl.log
    CHECK_RESULT $? 0 0 "rsa512 encryption and decryption operation speed fail"
    openssl speed -elapsed aes-128-cbc >> openssl.log
    grep "aes-128 cbc"  openssl.log
    CHECK_RESULT $? 0 0 "aes-128-cbc encryption and decryption operation speed fail"
    openssl speed -elapsed -evp sm3 >> openssl.log
    grep "sm3" openssl.log
    CHECK_RESULT $? 0 0 "sm3 encryption and decryption operation speed fail"
    openssl speed -elapsed -evp sm4 >> openssl.log
    grep "sm4-cbc" openssl.log
    CHECK_RESULT $? 0 0 "sm4 encryption and decryption operation speed fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f openssl.log
    LOG_INFO "Finish restoring the test environment."
}
main "$@"
