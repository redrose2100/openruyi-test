#!/usr/bin/bash
# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   754873891@qq.com
# @Date      :   2025/10/11
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mac-robber command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL mac-robber
    mkdir -p test_dir
    echo "test file" > test_dir/test_file.txt
    touch test_dir/empty_file
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mac-robber test_dir/ > output.txt
    CHECK_RESULT $? 0 0 "Check mac-robber directory failed"
    test -s output.txt
    CHECK_RESULT $? 0 0 "Check output content failed"
    mac-robber test_dir/ > output.txt
    CHECK_RESULT $? 0 0 "Check mac-robber directory failed"
    grep -q "test_file.txt" output.txt
    CHECK_RESULT $? 0 0 "Check test file in directory output failed"
    grep -q "empty_file" output.txt
    CHECK_RESULT $? 0 0 "Check empty file in directory output failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf test_dir test_file_output.txt  output.txt empty_output.txt 2>/dev/null
    LOG_INFO "End to restore the test environment."
}

main "$@"

