#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   leijie
# @Contact   :   1836111966@qq.com
# @Date      :   2024-07-31
# @License   :   Mulan PSL v2
# @Desc      :   Command test-unzstd
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL zstd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa | grep zstd
    CHECK_RESULT $? 0 0 "check zstd install"
    echo test_str > testfile
    zstd testfile
    CHECK_RESULT $? 0 0 "raw file"
    unzstd testfile.zst -o srcfile
    CHECK_RESULT $? 0 0 "check unzstd zst -o file"
    diff srcfile testfile
    CHECK_RESULT $? 0 0 "check unzstd"
    unzstd -2 -f --rm testfile.zst -o srcfile
    CHECK_RESULT $? 0 0 "check unzstd -2 -f --rm"
    test -f testfile.zst
    CHECK_RESULT $? 0 1 "check unzstd -2 -f --rm"
    unzstd -h > tmpfile
    CHECK_RESULT $? 0 0 "check unzstd help"
    grep "Usage" tmpfile
    CHECK_RESULT $? 0 0 "check unzstd help"
    grep "Advanced arguments" tmpfile
    CHECK_RESULT $? 0 0 "check unzstd help"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf testfile* tmpfile srcfile
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"