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
#@Desc          :   Test hwloc-calc_03,hwloc-diff
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
    hwloc-calc -q Machine:1 2>&1 | grep -v "0x0"
    CHECK_RESULT $? 1 0 "hwloc-calc -q failed"
    hwloc-calc --quiet Machine:1 2>&1 | grep -v "0x0"
    CHECK_RESULT $? 1 0 "hwloc-calc --quiet failed"
    hwloc-calc --verbose pu:0-1 2>&1 | grep "adding"
    CHECK_RESULT $? 0 0 "hwloc-calc --verbose failed"
    hwloc-calc -v pu:0-1 2>&1 | grep "adding"
    CHECK_RESULT $? 0 0 "hwloc-calc -v failed"
    hwloc-calc --version | grep "hwloc-calc"
    CHECK_RESULT $? 0 0 "hwloc-calc --version failed"
    hwloc-calc --input / Machine:0 | grep "0x"
    CHECK_RESULT $? 0 0 "hwloc-calc --input <directory>  failed"
    hwloc-calc --input "node:2 2" pu:0 | grep "0x00000001" 
    CHECK_RESULT $? 0 0 "hwloc-calc --input 'node:2 2' failed"
    hwloc-calc --input ./common/input_test.xml --input-format xml Machine:0 | grep '0x'
    CHECK_RESULT $? 0 0 "hwloc-calc --input-format <format> failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"