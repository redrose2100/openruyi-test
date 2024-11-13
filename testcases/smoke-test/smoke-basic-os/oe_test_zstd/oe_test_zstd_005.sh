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
# @Desc      :   Command test-zstdmt
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
    zstdmt -2 testfile
    CHECK_RESULT $? 0 0 "check zstdmt -2 file"
    zstdmt -d testfile.zst -o tmpfile
    CHECK_RESULT $? 0 0 "check zstdmt -d zst -o file"
    diff tmpfile testfile
    CHECK_RESULT $? 0 0 "check zstdmt -d zst -o file"
    zstdmt -f -d testfile.zst
    CHECK_RESULT $? 0 0 "check zstdmt -f -d zst"
    zstdmt --rm -f testfile
    CHECK_RESULT $? 0 0 "check zstdmt --rm -f file"
    test -f testfile
    CHECK_RESULT $? 0 1 "check zstdmt --rm -f file"
    zstdmt -d --rm -f testfile.zst
    CHECK_RESULT $? 0 0 "check zstdmt -d zst"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf testfile* tmpfile
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"