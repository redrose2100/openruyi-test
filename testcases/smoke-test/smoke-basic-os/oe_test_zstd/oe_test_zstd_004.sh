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
# @Desc      :   Command test-zstdcat
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
    zstdcat testfile.zst | grep -w "test_str"
    CHECK_RESULT $? 0 0 "check zstdcat zstfile"
    zstdcat testfile.zst -o tmpfile
    CHECK_RESULT $? 0 0 "check zstdcat -o"
    diff testfile tmpfile
    CHECK_RESULT $? 0 0 "check zstdcat -o"
    echo y | zstdcat testfile.zst -o tmpfile
    CHECK_RESULT $? 0 0 "check zstdcat zst -o file"
    zstdcat -f testfile.zst -o tmpfile
    CHECK_RESULT $? 0 0 "check zstdcat -f zst -o file"
    zstdcat --rm testfile.zst
    CHECK_RESULT $? 0 0 "check zstdcat --rm"
    test -f testfile.zst
    CHECK_RESULT $? 0 1 "Return value error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf testfile* tmpfile
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"