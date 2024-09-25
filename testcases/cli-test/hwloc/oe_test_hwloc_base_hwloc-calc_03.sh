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
    hwloc-calc -i "node:1 2" --physical-output -I pu Machine:0 | grep "0,1"
    CHECK_RESULT $? 0 0 "hwloc-calc --physical-output failed"
    hwloc-calc --input ./common/input_test.xml Machine:0 | grep "0x0000000f"
    CHECK_RESULT $? 0 0 "hwloc-calc --input <XML file> failed"
    hwloc-calc -i "node:1 2" --number-of pu Machine:0 | grep "2"
    CHECK_RESULT $? 0 0 "hwloc-calc--number-of failed"
    hwloc-calc -i "node:1 2" --intersect pu Machine:0 | grep "0,1"
    CHECK_RESULT $? 0 0 "hwloc-calc --intersect failed"
    hwloc-calc -i 'node:2 2' --hierarchical pu node:0-1
    CHECK_RESULT $? 0 0 "hwloc-calc --hierarchical failed"
    hwloc-calc --logical pu:0 | grep "0x00000001"
    CHECK_RESULT $? 0 0 "hwloc-calc --logical failed"
    hwloc-calc --physical pu:0 | grep "0x00000001"
    CHECK_RESULT $? 0 0 "hwloc-calc --physical failed"
    hwloc-calc --logical-input pu:0 | grep "0x00000001"
    CHECK_RESULT $? 0 0 "hwloc-calc --logical-input failed"
    hwloc-calc -i "node:1 2" --logical-output -I pu Machine:0 | grep "0,1"
    CHECK_RESULT $? 0 0 "hwloc-calc --logical-output failed"
    hwloc-calc --pi pu:0 | grep "0x00000001"
    CHECK_RESULT $? 0 0 "hwloc-calc --physical-input failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
