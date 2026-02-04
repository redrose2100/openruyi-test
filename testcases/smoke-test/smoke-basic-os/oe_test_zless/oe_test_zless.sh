#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   Lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2026-01-30
#@License       :   Mulan PSL v2
#@Desc          :   Basic test about zless
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    echo "Test file content for zless" > test.txt
    gzip -c test.txt > test.txt.gz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."
    zless test.txt.gz > output.txt
    diff test.txt output.txt
    CHECK_RESULT $? 0 0 "File output mismatch"
    echo "Stdin test content" | gzip | zless > output_stdin.txt
    grep "Stdin test content" output_stdin.txt
    CHECK_RESULT $? 0 0 "Stdin output missing"
    LOG_INFO "End to run test."
}

function post_test() {
    
    LOG_INFO "Start to restore the test environment."
    rm -f test.txt test.txt.gz output.txt output_stdin.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
