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
#@Desc          :   Test hwloc-calc_2
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
    hwloc-calc -i "node:1 2" --po -I pu Machine:0 | grep "0,1"
    CHECK_RESULT $? 0 0 "hwloc-calc --po failed"
    hwloc-calc -i 'node:2 2' --sep "," Mechine:0 | grep '0x'
    CHECK_RESULT $? 0 0 "hwloc-calc --sep <sep> failed"
    hwloc-calc --taskset pu:0 | grep "0x1"
    CHECK_RESULT $? 0 0 "hwloc-calc --taskset failed"
    hwloc-calc --single core:0 | grep "0x00000001"
    CHECK_RESULT $? 0 0 "hwloc-calc --single failed"
    hwloc-calc  --restrict 0x00000001 Machine:0 | grep "0"
    CHECK_RESULT $? 0 0 "hwloc-calc --restrict <cpuset> failed"
    hwloc-calc --whole-system --largest Machine:0 | grep "Machine:0"
    CHECK_RESULT $? 0 0 "hwloc-calc --whole-system failed"
    hwloc-calc -i ./common/input_test.xml Machine:0 | grep "0x0000000f"
    CHECK_RESULT $? 0 0 "hwloc-calc  -i <XML file> failed"
    hwloc-calc -i / Machine:0 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-calc -i <directory> failed"
    hwloc-calc -i "node:2 2" pu:0 | grep "0x00000001"
    CHECK_RESULT $? 0 0 "hwloc-calc -i 'node:2 2' failed"
    hwloc-calc --input ./common/input_test.xml --if xml Machine:0 | grep '0x'
    CHECK_RESULT $? 0 0 "hwloc-calc --if <format> failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
