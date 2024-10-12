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
# @Date      :   2024-10-09
# @License   :   Mulan PSL v2
# @Desc      :   test echo
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    ls output.txt && rm -rf output.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    echo "" > output.txt
    grep -q "^$" output.txt
    CHECK_RESULT $? 0 0 "Empty line output execution failed."

    echo -e "\033[31mThis is red text\033[0m" > output.txt
    grep "red text" output.txt
    CHECK_RESULT $? 0 0 "Colored output execution failed."

    echo -n "No new line" > output.txt
    last_char=$(tail -c 1 output.txt)
    [[ "$last_char" != $'\n' ]]
    CHECK_RESULT $? 0 0 "No new line output execution failed."

    echo "   Leading and trailing spaces   " > output.txt
    grep -q "Leading and trailing spaces" output.txt
    CHECK_RESULT $? 0 0 "Spaces output execution failed."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf output.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"