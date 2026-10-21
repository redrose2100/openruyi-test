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
# @Date      :   2026-4-30
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
    fc-list -q "NonExistentFontXYZ123" 2>/dev/null
    CHECK_RESULT $? 1 0 "Quiet mode with non-existent font should exit with 1"  
    fc-list -f 'Font: %{family} | Style: %{style} | File: %{file}\n' | head -5
    CHECK_RESULT $? 0 0 "Complex format string failed" 
    fc-list "Arial" "Times"
    CHECK_RESULT $? 0 0 "Multiple patterns failed"
    fc-list "Arial:*" | head -5
    CHECK_RESULT $? 0 0 "Pattern with wildcard failed" 
    fc-list :style=Regular family | head -10
    CHECK_RESULT $? 0 0 "Element filtering failed"
    fc-list -v -f '%{family}\n' "Arial" family
    CHECK_RESULT $? 0 0 "All short options combination failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG="$OLD_LANG"
    rm -rf "$TEST_DIR"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
