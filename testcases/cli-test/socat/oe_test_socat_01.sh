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
# shellcheck disable=SC2009,SC2035
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL socat
    echo "hello world" >a.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    socat -V | grep "socat version $(rpm -q socat --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check socat -V failed"
    socat -h | grep -Pz "Usage:[\S\s]*socat \[options\]"
    CHECK_RESULT $? 0 0 "Check socat -h failed"
    socat -hh | grep -Pz 'Usage:[\S\s]*socat \[options\]'
    CHECK_RESULT $? 0 0 "Check socat -hh failed"
    socat -hhh | grep -Pz 'Usage:[\S\s]*socat \[options\]'
    CHECK_RESULT $? 0 0 "Check socat -hhh failed"
    socat -u open:a.txt tcp-listen:4000,reuseaddr &
    SLEEP_WAIT 5
    socat -b 8192 tcp:127.0.0.1:4000 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -b failed"
    socat -u open:a.txt tcp-listen:4001,reuseaddr &
    SLEEP_WAIT 5
    socat -4 tcp:127.0.0.1:4001 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -4 failed"
    socat -u open:a.txt tcp-listen:4002,reuseaddr &
    SLEEP_WAIT 5
    socat -6 tcp:'[::1]':4002 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -6 failed"
    socat -U open:a.txt tcp-listen:4003,reuseaddr &
    SLEEP_WAIT 5
    socat -U tcp:127.0.0.1:4003 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -U failed"
    socat -g open:a.txt tcp-listen:4004,reuseaddr &
    SLEEP_WAIT 5
    socat -g tcp:127.0.0.1:4004 open:a.txt,create
    CHECK_RESULT $? 0 0 "Check socat -g failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ps -ef | grep "socat -u open" | grep -v grep | awk '{print $2}' | xargs kill -9
    rm -rf *.txt
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
