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
    diff -Naur 1.txt 2.txt >test1.patch
    diff -Naur 2.txt 3.txt >test2.patch
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    interdiff -z --interpolate test1.patch test2.patch | grep "\-bbb"
    CHECK_RESULT $? 0 0 "Check interdiff -z --interpolate test1.patch test2.patch failed"
    interdiff --combine test1.patch test2.patch | grep "\--- 1.txt"
    CHECK_RESULT $? 0 0 "Check interdiff --combine test1.patch test2.patch failed"
    interdiff --flip test1.patch test2.patch | grep "=== 8< === cut here === 8< ==="
    CHECK_RESULT $? 0 0 "Check interdiff --flip test1.patch test2.patch failed"
    interdiff --no-revert-omitted test1.patch test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check interdiff --no-revert-omitted test1.patch test2.patch failed"
    espdiff --help 2>&1 | grep "usage: espdiff"
    CHECK_RESULT $? 0 0 "Check espdiff --help failed"
    espdiff --version | grep "espdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check espdiff --version failed"
    espdiff --deep-brainwave-mode --recurse --compare 1.txt 2>&1 | grep "No brainwave activity detected"
    CHECK_RESULT $? 0 0 "Check espdiff --deep-brainwave-mode --recurse --compare failed"
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
