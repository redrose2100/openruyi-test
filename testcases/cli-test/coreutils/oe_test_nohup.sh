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
# @Author    :   huangcan
# @Contact   :   huangcan@uniontech.com
# @Date      :   2024-08-16
# @License   :   Mulan PSL v2
# @Desc      :   test nohup
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    nohup --help
    CHECK_RESULT $? 0 0 "nohup execute fail"
    nohup top > file.all 2>&1 &
    CHECK_RESULT $? 0 0 "nohup top execute fail"
    cat file.all
    CHECK_RESULT $? 0 0 "nohup execute fail"

    nohup sleep 30 >/dev/null 2>&1 &
    pid=$!
    ps -p $pid >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Background process not running"
    
    error_file="nohup_error.out"
    nohup ls /nonexistent >/dev/null 2>"$error_file" &
    sleep 1
    [ -s "$error_file" ]
    CHECK_RESULT $? 0 0 "Error output not redirected properly"
    
    nohup echo "test message" > cmd_compat.out 2>&1
    grep -q "test message" cmd_compat.out
    CHECK_RESULT $? 0 0 "Command compatibility test failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f file.all nohup_error.out cmd_compat.out
    pkill -f "sleep 30" 2>/dev/null
    LOG_INFO "End to restore the test environment."
}

main "$@"
