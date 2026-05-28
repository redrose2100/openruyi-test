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
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2026.04.21
# @License   :   Mulan PSL v2
# @Desc      :   taskset formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    nohup taskset -c 0,2 ping localhost &
    CHECK_RESULT $? 0 0 "taskset error"
    ping_pid=$(pgrep ping) 
    taskset -cp "$ping_pid" | grep "current affinity list: 0,2"
    CHECK_RESULT $? 0 0 "taskset error"
    kill -9 "$ping_pid"
    taskset 0x1 ping -c 1 localhost &> /dev/null
    CHECK_RESULT $? 0 0 "CPU mask 0x1 failed"
    nohup taskset -c 0 ping -c 3 localhost &> /dev/null &
    wait $!  # 等待进程结束
    CHECK_RESULT $? 0 0 "Bind to CPU 0 failed"
    nohup ping localhost &> /dev/null &
    test_pid=$!
    taskset -a -cp 0 $test_pid &> /dev/null
    CHECK_RESULT $? 0 0 "taskset -a parameter failed"    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 "$test_pid"
    rm -rf nohup.out
    LOG_INFO "End to restore the test environment."
}

main "$@"

