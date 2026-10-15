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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-12-18
# @License   :   Mulan PSL v2
# @Desc      :   default acl inherit fun02
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL net-tools
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    netstat -st 
    CHECK_RESULT $? 0 0 "display statistics for tcp ports fail"
    netstat -su
    CHECK_RESULT $? 0 0 "display statistics for udp ports fail"
    netstat -pt | grep -A5 "PID/Program"
    CHECK_RESULT $? 0 0 "show PID and process name fail"
    netstat -an 
    CHECK_RESULT $? 0 0 "should show in number"
    netstat -an --numeric-ports
    CHECK_RESULT $? 0 0 "show all ports fail"
    netstat -an | grep ':22'
    CHECK_RESULT $? 0 0 "show the process of port 22 fail"
    netstat --verbose
    CHECK_RESULT $? 0 0 "should show address families that not supported"
    netstat -r | grep "Kernel IP routing table"
    CHECK_RESULT $? 0 0 "show core routing info fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
