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
# @Author    :   lihuan
# @Contact   :   lihuan@uniontech.com
# @Date      :   2024-10-15
# @License   :   Mulan PSL v2
# @Desc      :   test echo
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    # 清理之前的测试文件
    rm -rf output.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    echo "\"Quoted text\"" > output.txt
    grep "\"Quoted text\"" output.txt
    CHECK_RESULT $? 0 0 "Quoted string output execution failed."

    echo "This is an error message." >&2
    error_message=$( { echo "This is an error message." >&2; } 2>&1 )
    echo "$error_message" | grep "error message"
    CHECK_RESULT $? 0 0 "Error output execution failed."

    long_string=$(printf 'A%.0s' {1..300})
    echo "$long_string" > output.txt
    grep -q "$long_string" output.txt
    CHECK_RESULT $? 0 0 "Long string output execution failed."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf output.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"