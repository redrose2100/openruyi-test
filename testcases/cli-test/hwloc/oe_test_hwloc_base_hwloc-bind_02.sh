#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhangshaowei
#@Contact       :   756800989@qq.com
#@Date          :   2022-08-15
#@License       :   Mulan PSL v2
#@Desc          :   Test hwloc-bind
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    hwloc-bind --nodeset core:0 hwloc-info core:0 | grep "Core"
    CHECK_RESULT $? 0 0 "hwloc-bind --nodeset failed"
    hwloc-bind --taskset core:0 lstopo | grep "L#"
    CHECK_RESULT $? 0 0 "hwloc-bind --taskset failed"
    hwloc-bind --whole-system core:0 echo 'demo' | grep "demo"
    CHECK_RESULT $? 0 0 "hwloc-bind --whole-system failed"
    hwloc-bind -v hwloc-ps -a | grep 'Machine'
    CHECK_RESULT $? 0 0 "hwloc-bind -v failed"
    hwloc-bind -q core:0 hwloc-ps -a | grep 'hwloc-ps'
    CHECK_RESULT $? 0 0 "hwloc-bind -q failed"
    hwloc-bind --pid core:0 ps | grep "PID"
    CHECK_RESULT $? 0 0 "hwloc-bind --pid failed"
    hwloc-bind --tid core:0 echo 'hello' | grep "hello"
    CHECK_RESULT $? 0 0 "hwloc-bind --tid failed"
    hwloc-bind --restrict 0x00000001 hwloc-info | grep "Package"
    CHECK_RESULT $? 0 0 "hwloc-bind ---restrict failed"
    hwloc-bind --hbm core:0 hwloc-ps -a | grep 'Machine'
    CHECK_RESULT $? 0 0 "hwloc-bind --hbm failed"
    hwloc-bind -f core:0 hwloc-ps -a | grep 'hwloc-ps'
    CHECK_RESULT $? 0 0 "hwloc-bind -f failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
