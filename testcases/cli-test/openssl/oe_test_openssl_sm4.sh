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
# @Date      :   2023-4-3
# @License   :   Mulan PSL v2
# @Desc      :   Command openssl sm4
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch file1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    expect <<EOF
    spawn openssl enc -sm4 -pbkdf2 -in file1 -out file1.sm4
    expect "*assword:" { send "123456\\r" }
    expect "*assword:" { send "123456\\r" }
    expect eof
EOF
    CHECK_RESULT $? 0 0 "sm4 encrypt file fail "
    expect <<EOF
    spawn openssl enc -sm4 -pbkdf2 -d -in file1.sm4 -out file2
    expect "*assword:" { send "123456\\r" }
    expect eof
EOF
    CHECK_RESULT $? 0 0 "sm4 decrypt file fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f file1 file1.sm4 file2
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
