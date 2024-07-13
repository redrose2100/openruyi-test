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
# @Desc      :   Test hwloc-info
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
    hwloc-info -h | grep "Usage"
    CHECK_RESULT $? 0 0 "hwloc-info -h failed"
    hwloc-info --version | grep "hwloc-info"
    CHECK_RESULT $? 0 0 "hwloc-info --version failed"
    hwloc-info --objects core:0 | grep 'type = Core'
    CHECK_RESULT $? 0 0 "hwloc-info --object failed"
    lstopo -l ./test.xml
    hwloc-info -i test.xml | grep 'depth'
    CHECK_RESULT $? 0 0 "hwloc-info -i <file> failed"
    hwloc-info -i / --verbose | grep "/"
    CHECK_RESULT $? 0 0 "hwloc-info -i <directory> failed"
    hwloc-info -s core:0 | grep 'Core:0'
    CHECK_RESULT $? 0 0 "hwloc-info -s failed"
    hwloc-info -v core:0 | grep 'Core L#0'
    CHECK_RESULT $? 0 0 "hwloc-info -v failed"
    hwloc-info --ancestors -l package:0 | grep 'Machine L#0'
    CHECK_RESULT $? 0 0 "hwloc-info --ancestors failed"
    hwloc-info --ancestor core pu:0 | grep 'type = Core'
    CHECK_RESULT $? 0 0 "hwloc-info --ancestor <type> failed"
    lstopo -i "node:2 8" ./old.xml
    hwloc-info --thissystem -i old.xml pu:all | grep "PU L#15"
    CHECK_RESULT $? 0 0 "hwloc-info --thissystem failed"
    LOG_INFO "End of the test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./*.xml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
