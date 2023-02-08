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
    socat -u open:a.txt tcp-listen:4015,reuseaddr &
    SLEEP_WAIT 5
    socat -lf out.log tcp:127.0.0.1:4015 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -lf failed"
    socat -u open:a.txt tcp-listen:4016,reuseaddr &
    SLEEP_WAIT 5
    socat -ly tcp:127.0.0.1:4016 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -ly failed"
    socat -u open:a.txt tcp-listen:4017,reuseaddr &
    SLEEP_WAIT 5
    socat -D tcp:127.0.0.1:4017 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -D failed"
    socat -u open:a.txt tcp-listen:4018,reuseaddr &
    SLEEP_WAIT 5
    socat -d tcp:127.0.0.1:4018 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -d failed"
    socat -u -L c.txt open:a.txt tcp-listen:4019,reuseaddr &
    SLEEP_WAIT 5
    socat -d tcp:127.0.0.1:4019 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -L failed"
    socat -u -W d.txt open:a.txt tcp-listen:4020,reuseaddr &
    SLEEP_WAIT 5
    socat -d tcp:127.0.0.1:4020 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -W failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ps -ef | grep "socat -u" | grep -v grep | awk '{print $2}' | xargs kill -9
    rm -rf *.txt
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
