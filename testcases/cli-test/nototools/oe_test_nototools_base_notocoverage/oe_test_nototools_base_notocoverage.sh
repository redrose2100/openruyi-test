#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/08/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST notocoverage in nototools options
# #############################################

source "../common/common.sh"

# Preloaded data, parameter configuration
function config_params() {
    LOG_INFO "Start to config params of the case."

    TMP_DIR="$(mktemp -d -t nototools.XXXXXXXXXXXX)"

    LOG_INFO "End to config params of the case."
}

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    common_pre
    cp -rf ./*.ttf ${TMP_DIR}

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    # Compare Help Information for consistency
    notocoverage -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    notocoverage --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    #Test the --ranges parameter
    notocoverage --ranges ./font1.ttf | grep -q "ranges"
    CHECK_RESULT $? 0 0 "option: --ranges error"

    cd ${TMP_DIR}

    #Test the --text parameter
    notocoverage --text ./font1.ttf | grep -q "2017 characters (of 2188)" && \
        cat font1_chars.txt | grep -q "Ј Љ Њ Ћ Ќ Ѝ Ў Џ А Б В Г"
    CHECK_RESULT $? 0 0 "option: --text error"

    cd - > /dev/null

    #Test the --sep parameter
    for i in "@" "$" "." "-"
    do
        notocoverage --sep ${i} ./font1.ttf | grep -q "U+051B CYRILLIC SMALL LETTER QA"
        CHECK_RESULT $? 0 0 "option: --sep ${i} error"
    done

    #Test the --info parameter
    notocoverage --info ./font1.ttf | grep -q "U+051B CYRILLIC SMALL LETTER QA"
    CHECK_RESULT $? 0 0 "option: --info error"
    
    #Test the --chars_per_line parameter
    notocoverage --chars_per_line 10 ./font1.ttf | grep -q "U+051B CYRILLIC SMALL LETTER QA"
    CHECK_RESULT $? 0 0 "option: --chars_per_line error"

    #Test the --limit parameter
    notocoverage --limit 0-7F ./font1.ttf | grep -q "limit to: 0000-007f"
    CHECK_RESULT $? 0 0 "option: --limit error"
    
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ${TMP_DIR}
    common_post

    LOG_INFO "End to restore the test environment."
}

main "$@"