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
    hwloc-info -n --ancestors core:0 | grep '0.0:  type = Core'
    CHECK_RESULT $? 0 0 "hwloc-info -n failed"
    hwloc-info --whole-io | grep 'Bridge'
    CHECK_RESULT $? 0 0 "hwloc-info --whole-io failed"
    hwloc-info --input "node:2 2" | grep '2 NUMANode'
    CHECK_RESULT $? 0 0 "hwloc-info --input 'node:2 2' failed"
    hwloc-info --restrict 0x00000003 | grep "depth"
    CHECK_RESULT $? 0 0 "hwloc-info --restrict <cpuset> failed"
    hwloc-info --restrict binding | grep "Machine"
    CHECK_RESULT $? 0 0 "hwloc-info --restrict binding failed"
    hwloc-info --pid 0 | grep 'Package'
    CHECK_RESULT $? 0 0 "hwloc-info --pid <pid> failed"
    LOG_INFO "End of the test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
