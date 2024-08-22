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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc-info --help | grep "Usage"
    CHECK_RESULT $? 0 0 "hwloc-info -h failed"
    hwloc-info --physical | grep "type #1"
    CHECK_RESULT $? 0 0 "hwloc-info --physical failed"
    hwloc-info --logical | grep 'depth'
    CHECK_RESULT $? 0 0 "hwloc-info --logical failed"
    hwloc-info --verbose core:0 | grep 'Core L#0'
    CHECK_RESULT $? 0 0 "hwloc-info -v failed"
    hwloc-info --silent core:0 | grep 'Core:0'
    CHECK_RESULT $? 0 0 "hwloc-info --slient failed"
    hwloc-info -i "node:2 2" | grep '2 NUMANode'
    CHECK_RESULT $? 0 0 "hwloc-info -i 'node:2 2' failed"
    hwloc-info -l --whole-system | grep "type #1"
    CHECK_RESULT $? 0 0 "hwloc-info --whole-system failed"
    lstopo -i "node:2 8" ./old.xml
    hwloc-info --input old.xml | grep 'depth'
    CHECK_RESULT $? 0 0 "hwloc-info --input failed"
    hwloc-info --input / --verbose | grep "/"
    CHECK_RESULT $? 0 0 "hwloc-info --input <directory> failed"
    hwloc-info --if xml -i old.xml | grep '2 NUMANode'
    CHECK_RESULT $? 0 0 "hwloc-info --if <format> failed"
    LOG_INFO "End of the test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf old.xml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
