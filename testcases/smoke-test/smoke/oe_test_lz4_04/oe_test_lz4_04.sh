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
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2025-11-19
# @License   :   Mulan PSL v2
# @Desc      :   Test lz4 error handling for corrupted files
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run error handling test."
    # Test Compress non-existent input file
    lz4 non_existent_input.txt output.lz4 2>/dev/null
    CHECK_RESULT $? 1 0 "Should fail on non-existent input file"

    # Test Decompress non-existent file
    lz4 -d non_existent_file.lz4 output.txt 2>/dev/null
    CHECK_RESULT $? 1 0 "Should fail on non-existent file"
    
    # Test Force overwrite with invalid input (should still fail)
    lz4 -f /dev/null/invalid_path output.lz4 2>/dev/null
    CHECK_RESULT $? 1 0 "Should fail on invalid input path even with -f"
    
    # Test Permission denied on output (simulate by using invalid path)
    echo "This is test data for error handling testing" > test_data.txt
    lz4 test_data.txt /proc/output.lz4 2>/dev/null
    CHECK_RESULT $? 1 0 "Should fail on permission denied output"
    LOG_INFO "End to run error handling test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test_data* output*
    LOG_INFO "End to restore the test environment."
}

main "$@"
