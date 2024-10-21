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
#@Date          :   2022-08-12
#@License       :   Mulan PSL v2
#@Desc          :   Test hwloc-calc_1
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
    hwloc-calc -i "node:1 2" pu:0-1 | grep "0x00000003" 
    CHECK_RESULT $? 0 0 "hwloc-calc [default] failed"
    hwloc-calc -i "node:1 2" -N pu Machine:0 | grep "2" 
    CHECK_RESULT $? 0 0 "hwloc-calc -N failed"
    hwloc-calc -i "node:1 2" -I pu Machine:0 | grep "0,1" 
    CHECK_RESULT $? 0 0 "hwloc-calc -I failed"
    hwloc-calc -i 'node:2 2' -H pu node:0-1 | grep "PU:0"  
    CHECK_RESULT $? 0 0 "hwloc-calc -H failed"
    hwloc-calc -i "node:1 2" --largest 0x00000002 | grep "PU:1"
    CHECK_RESULT $? 0 0 "hwloc-calc --largest failed"
    hwloc-calc -l pu:0 | grep "0x00000001" 
    CHECK_RESULT $? 0 0 "hwloc-calc -l failed"
    hwloc-calc -p pu:0 | grep "0x00000001" 
    CHECK_RESULT $? 0 0 "hwloc-calc -p failed"
    hwloc-calc --li pu:0 | grep "0x00000001" 
    CHECK_RESULT $? 0 0 "hwloc-calc --li failed"
    hwloc-calc -i "node:1 2" --lo -I pu Machine:0 | grep "0,1" 
    CHECK_RESULT $? 0 0 "hwloc-calc --lo failed"
    hwloc-calc --pi pu:0 | grep "0x00000001" 
    CHECK_RESULT $? 0 0 "hwloc-calc --pi failed" 
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
