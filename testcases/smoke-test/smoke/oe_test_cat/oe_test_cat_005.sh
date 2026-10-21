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
# @Date      :   2024-09-12
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-top
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG="$LANG"
    export LANG=en_US.UTF-8
    echo "Initial content" > append_test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    echo "Appended content" | cat >> append_test.txt
    tail -n 1 append_test.txt | grep "Appended content"
    CHECK_RESULT $?  0 0 "Test failed: Content not found in the file."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f append_test.txt
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"