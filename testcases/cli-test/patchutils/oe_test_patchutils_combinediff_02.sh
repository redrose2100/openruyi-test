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
    combinediff --combine test1.patch test2.patch |grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff --combine test1.patch test2.patch  failed"
    combinediff --flip test1.patch test2.patch |grep "=== 8< === cut here === 8< ==="
    CHECK_RESULT $? 0 0 "Check combinediff --flip test1.patch test2.patch  failed"
    combinediff --no-revert-omitted test1.patch test2.patch |grep "@@ -1,2 +1,4 @@"
    CHECK_RESULT $? 0 0 "Check combinediff --no-revert-omitted test1.patch test2.patch  failed"
    dehtmldiff --help | grep "usage: dehtmldiff"
    CHECK_RESULT $? 0 0 "Check dehtmldiff --help  failed"
    dehtmldiff --version | grep "dehtmldiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check dehtmldiff --version  failed"
    dehtmldiff t1.html |grep "Hello"
    CHECK_RESULT $? 0 0 "Check dehtmldiff t1.html  failed"
    editdiff --help | grep "usage: editdiff"
    CHECK_RESULT $? 0 0 "Check editdiff --help  failed"
    editdiff --version | grep "editdiff - patchutils version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check editdiff --version  failed"
    echo :q |editdiff 1.txt
    CHECK_RESULT $? 0 0 "Check echo :q |editdiff 1.txt  failed"
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
