#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

##############################################
#@Author    :   zhangshaowei
#@Contact   :   756800989@qq.com
#@Date      :   2022/07/26
#@License   :   Mulan PSL v2
#@Desc      :   Test hwloc-bind
##############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc-bind --no-smt core:0 hwloc-ps -a | grep "hwloc-ps"
    CHECK_RESULT $? 0 0 "hwloc-bind --no-smt failed"
    hwloc-bind -h | grep "Usage: hwloc-bind"
    CHECK_RESULT $? 0 0 "hwloc-bind -h failed"
    hwloc-bind --help | grep "Usage: hwloc-bind"
    CHECK_RESULT $? 0 0 "hwloc-bind --help failed"
    hwloc-bind --disallowed Core:0 hwloc-info | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-bind --disallowed failed"
    hwloc-bind --best-memattr 1 core:0 ps | grep "PID"
    CHECK_RESULT $? 0 0 "hwloc-bind --best-memattr failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
