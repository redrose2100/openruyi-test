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
    DNF_INSTALL socat
    echo "hello world" >a.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    socat -u open:a.txt tcp-listen:4005,reuseaddr &
    SLEEP_WAIT 5
    socat -T 3 tcp:127.0.0.1:4005 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -T failed"
    socat -u open:a.txt tcp-listen:4006,reuseaddr &
    sleep  5
    socat -t 3 tcp:127.0.0.1:4006 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -T failed"
    socat -u open:a.txt tcp-listen:4007,reuseaddr &
    SLEEP_WAIT 5 
    socat -s tcp:127.0.0.1:4007 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -s failed"
    socat -u open:a.txt tcp-listen:4008,reuseaddr &
    SLEEP_WAIT 5
    socat -x -s tcp:127.0.0.1:4008 open:a.txt,create 2>&1 | grep 'length'
    CHECK_RESULT $? 0 0 "Check socat -x failed"
    socat -u open:a.txt tcp-listen:4009,reuseaddr &
    SLEEP_WAIT 5
    socat -v -s tcp:127.0.0.1:4009 open:a.txt,create 2>&1 | grep 'hello world'
    CHECK_RESULT $? 0 0 "Check socat -v failed"
    socat -u open:a.txt tcp-listen:4010,reuseaddr &
    SLEEP_WAIT 5
    socat -lh tcp:127.0.0.1:4010 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -lh failed"
    socat -u open:a.txt tcp-listen:4011,reuseaddr &
    SLEEP_WAIT 5
    socat -lu tcp:127.0.0.1:4011 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -lu failed"
    socat -u open:a.txt tcp-listen:4012,reuseaddr &
    SLEEP_WAIT 5
    socat -lp echo tcp:127.0.0.1:4012 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -lp failed"
    socat -u open:a.txt tcp-listen:4013,reuseaddr &
    SLEEP_WAIT 5
    socat -lm tcp:127.0.0.1:4013 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -lm failed"
    socat -u open:a.txt tcp-listen:4014,reuseaddr &
    SLEEP_WAIT 5
    socat -ls tcp:127.0.0.1:4014 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -ls failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ps -ef | grep "socat -u open" | grep -v grep | awk '{print $2}' | xargs kill -9
    rm -rf *.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
