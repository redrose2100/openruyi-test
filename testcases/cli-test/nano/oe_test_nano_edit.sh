#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Test nano basic text editing functionality
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/nano/common/nano_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nano"
    mkdir -p /tmp/nano_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/nano_test || exit 1

    # Test point 1: Create a new file and write content
    nano_write_save "" create.txt "hello nano editor"
    test -f create.txt
    CHECK_RESULT $? 0 0 "nano failed to create create.txt"
    grep "hello nano editor" create.txt
    CHECK_RESULT $? 0 0 "create.txt does not contain the text written by nano"

    # Test point 2: Open an existing file, append text, and save
    echo "original line" > edit.txt
    nano_write_save "" edit.txt "appended line"
    grep "original line" edit.txt
    CHECK_RESULT $? 0 0 "edit.txt lost original content after nano edit"
    grep "appended line" edit.txt
    CHECK_RESULT $? 0 0 "edit.txt does not contain the appended text"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/nano_test
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
