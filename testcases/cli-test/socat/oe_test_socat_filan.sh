#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of socat command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "socat time"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test"
    filan -h | grep -Pz "Usage:[\S\s]*filan \[options\]"
    CHECK_RESULT $? 0 0 "Check filan -h failed"
    filan -? | grep -Pz 'Usage:[\S\s]*filan \[options\]'
    CHECK_RESULT $? 0 0 "Check filan -? failed"
    filan -d
    CHECK_RESULT $? 0 0 "Check filan -d failed"
    filan -i 2 | awk '{print $1}' | grep -v FD | wc -l | grep 1
    CHECK_RESULT $? 0 0 "Check filan -i failed"
    filan -n 2 | awk '{print $1}' | grep -v FD | wc -l | grep 2
    CHECK_RESULT $? 0 0 "Check filan -n failed"
    filan -s | grep 'tty'
    CHECK_RESULT $? 0 0 "Check filan -s failed"
    filan -f /dev/pts/0 | grep 'device'
    CHECK_RESULT $? 0 0 "Check filan -f failed"
    /usr/bin/time filan -T 3 2>&1 | grep '%CPU'
    CHECK_RESULT $? 0 0 "Check filan -T failed"
    filan -r | grep atime
    CHECK_RESULT $? 0 0 "Check filan -r failed"
    filan -L 2>&1 | grep 'chrdev'
    CHECK_RESULT $? 0 0 "Check filan -L failed"
    filan -o a.txt
    grep 'device' a.txt
    CHECK_RESULT $? 0 0 "Check filan -o failed"
    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
