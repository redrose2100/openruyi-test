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
# @Author    :   zhangshaowei
# @Contact   :   756800989@qq.com
# @Date      :   2022/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test hwloc-ps
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc-ps -a | grep 'Machine:0'
    CHECK_RESULT $? 0 0 "hwloc-ps -a failed"
    Pid=$(ps -fC bash | sed '1d' | awk 'NR==1 {print $2}')
    out="$(hwloc-ps --pid "$Pid")"
    echo "$out" |grep "$Pid"
    CHECK_RESULT $? 0 0 "hwloc-ps --pid failed"
    hwloc-ps --pid "$Pid" -c | grep '0x'
    CHECK_RESULT $? 0 0 "hwloc-ps -c failed"
    hwloc-ps -e -a | grep 'hwloc-ps'
    CHECK_RESULT $? 0 0 "hwloc-ps -e failed"
    hwloc-ps --name 'bash' | grep 'bash'
    CHECK_RESULT $? 0 0 "hwloc-ps --name failed"
    hwloc-ps -a -p | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps -p failed"
    hwloc-ps -a -l | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps -l failed"
    hwloc-ps -t -a | grep "Machine:0"
    CHECK_RESULT $? 0 0 "hwloc-ps -t failed"
    hwloc-ps -a --pid-cmd echo | grep 'bash'
    CHECK_RESULT $? 0 0 "hwloc-ps --pid-cmd failed"
    hwloc-ps -a --whole-system | grep "systemd"
    CHECK_RESULT $? 0 0 "hwloc-ps --whole-system failed"
    LOG_INFO "End of the test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
