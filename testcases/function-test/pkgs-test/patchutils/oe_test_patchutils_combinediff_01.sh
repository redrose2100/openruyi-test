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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL patchutils
    mkdir patchutils
    cd patchutils || exit
    cp ../common/* ./
    diff -Naur 1.txt 2.txt >test1.patch
    diff -Naur 2.txt 3.txt >test2.patch
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    combinediff --help 2>&1 | grep "usage: combinediff"
    CHECK_RESULT $? 0 0 "Check combinediff --help  failed"
    combinediff --version | grep "combinediff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check combinediff --version  failed"
    combinediff -U 10 -i -w -b -B -q test1.patch test2.patch | grep "@@ -1 +1,2 @@"
    CHECK_RESULT $? 0 0 "Check combinediff -U 10 -i -w -b -B -q test1.patch test2.patch  failed"
    combinediff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch | grep "@@ -1 +1,2 @@"
    CHECK_RESULT $? 0 0 "Check combinediff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch  failed"
    combinediff -p 1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff -p 1 test1.patch test2.patch  failed"
    combinediff --strip-match=1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff --strip-match=1 test1.patch test2.patch  failed"
    combinediff -d 1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff -d 1 test1.patch test2.patch  failed"
    combinediff --drop-context=1 test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff --drop-context=1 test1.patch test2.patch  failed"
    combinediff -z --interpolate test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff -z --interpolate test1.patch test2.patch  failed"
    combinediff --decompress --interpolate test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff --decompress --interpolate test1.patch test2.patch  failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    cd ..
    rm -rf patchutils
    LOG_INFO "Finish restore the test environment."
}

main "$@"
