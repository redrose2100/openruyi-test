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
# @Date      :   2024-08-26
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-top
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG="$LANG"
    export LANG=en_US.UTF-8
    echo -e "Line 1\nLine 2\nLine 3" > numbered.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    res1="$(cat -n numbered.txt)"
    echo "$res1" | grep -E "^\s*1\sLine 1"
    CHECK_RESULT $?
    echo "$res1" | grep -E "^\s*3\sLine 3"
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f numbered.txt
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"