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
#@Desc      :   Test hwloc-gather-topology
##############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hwloc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hwloc-gather-topology --no-cpuid temp1 && [ -e "temp1.output" ]
    CHECK_RESULT $? 0 0 "hwloc-gather-topology --no-cpuid failed"
    hwloc-gather-topology --keep temp2 && [ -e "temp2.output" ]
    CHECK_RESULT $? 0 0 "hwloc-gather-topology --keep failed"
    hwloc-gather-topology --version | grep "hwloc-gather-topology"
    CHECK_RESULT $? 0 0 "hwloc-gather-topology --version failed"
    hwloc-gather-topology -h | grep "hwloc-gather-topology"
    CHECK_RESULT $? 0 0 "hwloc-gather-topology -h failed "
    hwloc-gather-topology --help | grep "hwloc-gather-topology"
    CHECK_RESULT $? 0 0 "hwloc-gather-topology --help failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf temp*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
