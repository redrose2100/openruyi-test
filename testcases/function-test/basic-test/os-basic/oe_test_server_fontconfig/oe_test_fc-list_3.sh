#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2026-4-29
# @License   :   Mulan PSL v2
# @Desc      :   command fc-list
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fontconfig"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    TEST_DIR="/tmp/fc-list_test"
    mkdir -p "$TEST_DIR"   
    TEST_FONT_FILE="$TEST_DIR/test_font.txt"
    echo "Arial:style=Regular" > "$TEST_FONT_FILE"
    echo "Times New Roman:style=Bold" >> "$TEST_FONT_FILE"
    echo "Courier New:style=Italic" >> "$TEST_FONT_FILE"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fc-list -q
    CHECK_RESULT $? 0 0 "Short quiet option failed"
    fc-list -h | grep -q "usage:"
    CHECK_RESULT $? 0 0 "Short help option failed"
    fc-list -v -f '%{family}\n' | head -10
    CHECK_RESULT $? 0 0 "Verbose with format combination failed"
    fc-list -b -q
    local brief_quiet_result=$?
    if [ $brief_quiet_result -eq 0 ] || [ $brief_quiet_result -eq 1 ]; then
        CHECK_RESULT $? 0 0 "Brief with quiet combination completed"
    else
        CHECK_RESULT $? 1 0 "Brief with quiet combination failed"
    fi

    fc-list "NonExistentFontXYZ123" 2>/dev/null
    local non_existent_result=$?
    if [ $non_existent_result -eq 0 ] || [ $non_existent_result -eq 1 ]; then
        CHECK_RESULT $? 0 0 "Non-existent font pattern handled correctly"
    else
        CHECK_RESULT $? 1 0 "Non-existent font pattern failed unexpectedly"
    fi   
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG="$OLD_LANG"
    rm -rf "$TEST_DIR"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
