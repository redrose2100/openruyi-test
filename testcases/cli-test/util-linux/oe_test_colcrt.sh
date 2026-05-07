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
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-03-14
#@License       :   Mulan PSL v2
#@Desc          :   Test case for colcrt command
#####################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "util-linux"
    echo -e "This is _\\bunderlined text." > input.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    colcrt input.txt > output.txt
    first_line=$(head -1 output.txt | tr -d '\n\r')
    second_line=$(tail -1 output.txt | tr -d '\n\r')
    # Key content after colcrt processing (format may vary by env)
    [[ "$first_line" == *"underlined"* ]] && [[ "$first_line" == *"text"* ]]
    CHECK_RESULT $? 0 0 "First line content check"
    # Underline line: spaces and dashes only (format varies by colcrt version)
    [[ "$second_line" =~ ^[[:space:]]*-+[[:space:]]*$ ]]
    CHECK_RESULT $? 0 0 "Underline rendering check"

    # Suppress underlining: util-linux colcrt uses '-' not --no-underlining
    colcrt - input.txt > output2.txt
    CHECK_RESULT $? 0 0 "colcrt - (no underlining) failed"
    line_count=$(wc -l < output2.txt)
    content=$(tr -d '\n\r' < output2.txt)
    [ "$line_count" -eq 1 ]
    CHECK_RESULT $? 0 0 "Line count check with no-underlining"
    [[ "$content" == *"underlined"* ]] && [[ "$content" == *"text"* ]]
    CHECK_RESULT $? 0 0 "Content check with no-underlining"

    colcrt --version
    CHECK_RESULT $? 0 0 "Version check"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f input.txt output.txt output2.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
