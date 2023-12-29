#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2023/12.27
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-pigz
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir /tmp/pigz
    touch /tmp/pigz/test.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    pigz -N /tmp/pigz/test.txt
    test -e /tmp/pigz/test.txt.gz
    CHECK_RESULT $? 0 0 "pigz -N command execution failure"
    pigz -d  -N /tmp/pigz/test.txt.gz
    test -e /tmp/pigz/test.txt
    CHECK_RESULT $? 0 0 "pigz -d command execution failure"
    pigz -11 -O /tmp/pigz/test.txt
    test -e /tmp/pigz/test.txt.gz
    CHECK_RESULT $? 0 0 "pigz -O command execution failure"
    pigz -d /tmp/pigz/test.txt.gz
    pigz -10 -O /tmp/pigz/test.txt
    test -e /tmp/pigz/test.txt.gz
    CHECK_RESULT $? 0 1 "pigz -O command execution failure"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/pigz
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

