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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023/08.17
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-pigz
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    mkdir /tmp/pigz /tmp/pigz/pigz01
    touch /tmp/pigz/1.txt /tmp/pigz/pigz01/1.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    pigz -z /tmp/pigz/1.txt
    test -e /tmp/pigz/1.txt.zz
    CHECK_RESULT $? 0 0 "pigz -z command execution failure"
    pigz -d /tmp/pigz/1.txt.zz
    test -e /tmp/pigz/1.txt
    CHECK_RESULT $? 0 0 "pigz -d command execution failure"
    pigz -k /tmp/pigz/1.txt
    test -e /tmp/pigz/1.txt && test -e /tmp/pigz/1.txt.gz
    CHECK_RESULT $? 0 0 "pigz -k command execution failure"
    pigz -f /tmp/pigz/1.txt
    CHECK_RESULT $? 0 0 "pigz -f command execution failure"
    pigz -r /tmp/pigz/pigz01/1.txt
    test -e /tmp/pigz/pigz01/1.txt.gz
    CHECK_RESULT $? 0 0 "pigz -r command execution failure"

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/pigz
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
