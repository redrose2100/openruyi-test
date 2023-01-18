#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of patchutils command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL patchutils
    mkdir patchutils
    cd patchutils
    cp ../common/* ./
    diff -Naur 2.txt 3.txt >test2.patch
    gzip 1.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    filterdiff --help 2>&1 | grep "usage: filterdiff"
    CHECK_RESULT $? 0 0 "Check filterdiff --help  failed"
    filterdiff -h 2>&1 | grep "usage: filterdiff"
    CHECK_RESULT $? 0 0 "Check filterdiff -h  failed"
    filterdiff --version | grep "filterdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check filterdiff --version  failed"
    filterdiff -x '*.c' --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff -x  failed"
    filterdiff --exclude='*.c' --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --exclude=  failed"
    filterdiff --exclude-from-file=pattern --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --exclude-from-file=pattern --lines=-5 test2.patch  failed"
    filterdiff -i '*.txt' --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check  filterdiff -i '*.txt' --lines=-5 test2.patch  failed"
    filterdiff --include='*.txt' --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --include='*.txt' --lines=-5 test2.patch  failed"
    filterdiff -I pattren --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff -I pattren --lines=-5 test2.patch  failed"
    filterdiff --include-from-file=pattren --lines=-5 test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check filterdiff --include-from-file=pattren --lines=-5 test2.patch  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf patchutils
    LOG_INFO "Finish restore the test environment."
}

main "$@"
