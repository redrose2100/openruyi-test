#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   Jingxu Li
# @Contact   :   jingxu@isrc.iscas.ac.cn
# @Date      :   2022/03/14
# @License   :   Mulan PSL v2
# @Desc      :   Test haproxy
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    LOG_INFO "Nothing to do"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOF_INFO "Start to run test"
    haproxy -f haproxy.cfg -V
    CHECK_RESULT $? 0 0 "failed to start haproxy"
    haproxy -f haproxy.cfg -D
    CHECK_RESULT $? 0 0 "failed to set haproxy process as daemon"
    haproxy -f haproxy.cfg -N 2000
    CHECK_RESULT $? 0 0 "failed to set the default per-proxy maxconn"
    haproxy -f haproxy.cfg -W
    CHECK_RESULT $? 0 0 "failed to set master-worker mode"
    haproxy -f haproxy.cfg -Ws
    CHECK_RESULT $? 0 0 "failed to set master-worker mode with supply of notify"
    haproxy -f haproxy.cfg -d
    CHECK_RESULT $? 0 0 "failed to enter haproxy debug mode"
    haproxy -f haproxy.cfg -dG
    CHECK_RESULT $? 0 0 "failed to disable use of getaddrinfo"
    haproxy -f haproxy.cfg -dM
    CHECK_RESULT $? 0 0 "failed to force memory poisoning"
    haproxy -f haproxy.cfg -dS
    CHECK_RESULT $? 0 0 "failed to disable use of the splice system call"
    haproxy -f haproxy.cfg -dV
    CHECK_RESULT $? 0 0 "failed to disable SSL verify on the server side"
    haproxy -f haproxy.cfg -dW
    CHECK_RESULT $? 0 0 "failed to refuse to start if any warning was emitted"
    haproxy -f haproxy.cfg -db
    CHECK_RESULT $? 0 0 "failed to disable background mode and multi-process mode"
    haproxy -f haproxy.cfg -de
    CHECK_RESULT $? 0 0 "failed to disable the use of epoll"
    haproxy -f haproxy.cfg -dk
    CHECK_RESULT $? 0 0 "failed to disable the use of kqueue"
    haproxy -f haproxy.cfg -dp
    CHECK_RESULT $? 0 0 "failed to disable the use of poll"
    haproxy -f haproxy.cfg -dr
    CHECK_RESULT $? 0 0 "failed to ignore server address resolution failures"
    haproxy -f haproxy.cfg -m 16384
    CHECK_RESULT $? 0 0 "failed to limit the total allocatable memory"
    haproxy -f haproxy.cfg -n 2000
    CHECK_RESULT $? 0 0 "failed to limit the per-process connection limit"
    haproxy -f haproxy.cfg -q
    CHECK_RESULT $? 0 0 "failed to set quiet mode"
    haproxy -f haproxy.cfg -vv | grep "HAProxy"
    CHECK_RESULT $? 0 0 "failed to display the version"

    LOG_INFO "End to run test"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "Finish test!"
}

main "$@"
