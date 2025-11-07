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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2025-11-7
# @License   :   Mulan PSL v2
# @Desc      :   command fc-list01
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
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
    fc-list --verbose | grep -i Pattern
    CHECK_RESULT $? 0 0 "Verbose output failed" 
    fc-list --brief | grep -i Pattern
    CHECK_RESULT $? 0 0 "Brief output failed"  
    fc-list --format='%{family}\n' | wc -l
    CHECK_RESULT $? 0 0 "Format option failed"   
    fc-list :lang=en
    CHECK_RESULT $? 0 0 "Quiet mode failed when fonts exist"
    fc-list --version > fc-list.log 2>&1
    grep fontconfig fc-list.log
    CHECK_RESULT $? 0 0 "Version display failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    export LANG="$OLD_LANG"
    rm -rf "$TEST_DIR" fc-list.log
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
