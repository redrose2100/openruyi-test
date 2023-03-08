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
#@Desc      :   Test hwloc-calc
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
    hwloc-calc -h | grep "Usage: hwloc-calc"
    CHECK_RESULT $? 0 0 "hwloc-calc -h failed"
    hwloc-calc --local-memory pu:0 | grep '0'
    CHECK_RESULT $? 0 0 "hwloc-calc --local failed"
    hwloc-calc --local-memory-flags 3 pu:0 | grep "0"
    CHECK_RESULT $? 0 0 "hwloc-calc ---local-memory-flags failed"
    hwloc-calc --best-memattr 1 pu:2 | grep "0"
    CHECK_RESULT $? 0 0 "hwloc-calc --best-memattr failed"
    hwloc-calc --no Machine:all | grep '0x'
    CHECK_RESULT $? 0 0 "hwloc-calc --no failed"
    hwloc-calc -n Machine:0 | grep "0x00"
    CHECK_RESULT $? 0 0 "hwloc-calc -n failed"
    hwloc-calc --no-smt pu:0 | grep "0x00"
    CHECK_RESULT $? 0 0 "hwloc-calc --no-smt failed"
    hwloc-calc --cpukind 0 pu:0 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-calc --cpukind <n> failed"
    hwloc-calc --cpukind pu:0 Machine:0 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-calc --cpukind <type> failed"
    hwloc-calc --ni -I pu Machine:0 | grep "0"
    CHECK_RESULT $? 0 0 "hwloc-calc --ni failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"