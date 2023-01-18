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
    grepdiff --include-from-file=pattren --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --include-from-file=pattren --lines=-5 aaa test2.patch  failed"
    grepdiff -# 1 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff -# 1 aaa test2.patch  failed"
    grepdiff --hunks=1 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --hunks=1 aaa test2.patch  failed"
    grepdiff -F 1 --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff -F 1 --lines=-5 aaa test2.patch  failed"
    grepdiff --files=1 --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --files=1 --lines=-5 aaa test2.patch  failed"
    grepdiff --annotate --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --annotate --lines=-5 aaa test2.patch  failed"
    grepdiff -v --as-numbered-lines=before --lines=-5 --output-matching=hunk aaa test2.patch | grep ":aaa"
    CHECK_RESULT $? 0 0 "Check grepdiff -v --as-numbered-lines=before --lines=-5 --output-matching=hunk aaa test2.patch  failed"
    grepdiff --format=context --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --format=context --lines=-5 aaa test2.patch  failed"
    grepdiff --output-matching=hunk --lines=-5 aaa test2.patch | grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check grepdiff --output-matching=hunk --lines=-5 aaa test2.patch  failed"
    grepdiff --remove-timestamps --lines=-5 aaa test2.patch | grep "2.txt"
    CHECK_RESULT $? 0 0 "Check grepdiff --remove-timestamps --lines=-5 aaa test2.patch  failed"
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
