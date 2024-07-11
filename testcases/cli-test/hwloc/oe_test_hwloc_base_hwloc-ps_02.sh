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

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    Pid=$(ps -fC bash | sed '1d' | awk 'NR==1 {print $2}')
    hwloc-ps --pid "$Pid" --cpuset | grep '0x'
    CHECK_RESULT $? 0 0 "hwloc-ps --cpuset failed"
    hwloc-ps --get-last-cpu-location -a | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps --get-last-cpu-location failed"
    hwloc-ps -a --physical | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps --physical failed"
    hwloc-ps -a --logical | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-ps --logical failed"
    hwloc-ps --threads -a | grep "Machine:0"
    CHECK_RESULT $? 0 0 "hwloc-ps --threads failed"
    LOG_INFO "End of the test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
