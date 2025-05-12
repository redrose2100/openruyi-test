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
# @Date      :   2024-1-29
# @License   :   Mulan PSL v2
# @Desc      :   command strace
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL strace
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    strace -V | grep version
    CHECK_RESULT $? 0 0 "show version fail"
    strace -h | grep Usage
    CHECK_RESULT $? 0 0 "show help fail"
    strace ls -h 
    CHECK_RESULT $? 0 0 "tracking cmd ls fail"
    strace -c ls -h > test01.log 2>&1
    grep calls test01.log
    CHECK_RESULT $? 0 0 "tracking the concise results fail"
    strace -e openat2 ls -h > test02.log 2>&1
    grep "exited with 0" test02.log
    CHECK_RESULT $? 0 0 "check openat2 call type fail"
    strace -t -e openat2 ls -h > test03.log 2>&1
    grep "exited with 0" test03.log
    CHECK_RESULT $? 0 0 "check openat2 call type with time fail"
    strace -t -o output.txt  ls -h
    CHECK_RESULT $? 0 0 "output the tracking result to the file fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test01.log test02.log test03.log output.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
