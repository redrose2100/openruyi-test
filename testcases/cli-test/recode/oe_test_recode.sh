#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangcan
# @Contact   :   huangcan@uniontech.com
# @Date      :   2024-09-03
# @License   :   Mulan PSL v2
# @Desc      :   test recode
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL "recode"
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start testing..."
    recode --help
    CHECK_RESULT $? 0 0 "recode install fail"
    recode -l | more
    CHECK_RESULT $? 0 0 "recode execute fail"
    touch page.txt
    echo "Hello, World!" > page.txt
    recode ..HTML <page.txt> page.html
    CHECK_RESULT $? 0 0 "recode execute fail"
    cat page.html
    CHECK_RESULT $? 0 0 "page.html generation failed"
    recode --version | grep -q "recode"
    CHECK_RESULT $? 0 0 "Version check failed"
    recode -l | head -5 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "recode -l command failed"    
    recode -T | head -2 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Subset detection test failed"
    echo "测试" | recode -si UTF-8..GB2312
    CHECK_RESULT $? 0 0 "Strict mode with iconv failed"
    echo "©" | recode -qf UTF-8..ASCII
    CHECK_RESULT $? 0 0 "Combined flags  test failed"
    echo "¥" | recode -f UTF-8..ASCII 
    CHECK_RESULT $? 0 0 "Currency symbol force-recode failed"
    echo "<p>Hello, World!</p>" > test.html
    CHECK_RESULT $? 0 0 "Failed to create test.html"
    recode HTML.. <test.html > test_decode.txt
    CHECK_RESULT $? 0 0 "HTML to text conversion failed"
    grep -q "Hello, World!" test_decode.txt
    CHECK_RESULT $? 0 0 "Decoded content mismatch"
    recode --silent us..latin1 /dev/null 2>/dev/null
    CHECK_RESULT $? 0 0 "Silent option test failed"
    touch empty.txt
    recode -t utf-8..utf-8 empty.txt 2>/dev/null
    CHECK_RESULT $? 0 0 "Touch option test failed"    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf page.txt
    rm -rf page.html
    rm -rf test.html test_decode.txt empty.txt
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
