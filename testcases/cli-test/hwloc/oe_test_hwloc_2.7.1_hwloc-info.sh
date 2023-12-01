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
#@Desc      :   Test hwloc-info
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
    hwloc-info --local-memory pu:0 | grep "NUMANode"
    CHECK_RESULT $? 0 0 "hwloc-info --local-memory failed"
    hwloc-info --local-memory-flags 3 | grep "#0"
    CHECK_RESULT $? 0 0 "hwloc-info --local-memory-flags <n> failed"
    hwloc-info --local-memory --best-memattr bandwidth | grep "depth 0"
    CHECK_RESULT $? 0 0 "hwloc-info --best-memattr failed"
    hwloc-info --restrict-flags 0 | grep 'Machine'
    CHECK_RESULT $? 0 0 "hwloc-info --restrict-flags <n> failed"
    hwloc-info --disallowed pu:all | grep "L#0"
    CHECK_RESULT $? 0 0 "hwloc-info --disallowed failed"
    hwloc-info --filter pu:all | grep "depth"
    CHECK_RESULT $? 0 0 "hwloc-info --filter <type>:<kind> failed"
    hwloc-info --restrict 0x00000001 | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-info --restrict failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"