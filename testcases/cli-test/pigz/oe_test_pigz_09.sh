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
# @Date      :   2024/02.06
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
    pigz -K /tmp/pigz/test.txt
    test -e /tmp/pigz/test.txt.zip
    CHECK_RESULT $? 0 0 "pigz -K command execution failure"
    pigz -d /tmp/pigz/test.txt.zip
    CHECK_RESULT $? 0 0 "pigz -d command execution failure"
    pigz -n /tmp/pigz/test.txt
    test -e /tmp/pigz/test.txt.gz
    CHECK_RESULT $? 0 0 "pigz -n command execution failure"
    pigz -d /tmp/pigz/test.txt.gz 
    CHECK_RESULT $? 0 0 "pigz -d command execution failure"
    pigz --huffman /tmp/pigz/test.txt
    test -e /tmp/pigz/test.txt.gz
    CHECK_RESULT $? 0 0 "pigz --huffman command execution failure"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/pigz
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

