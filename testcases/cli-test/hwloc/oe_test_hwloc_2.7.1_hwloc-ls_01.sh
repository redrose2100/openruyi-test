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
#@Desc      :   Test hwloc-ls
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
    hwloc-ls --cpukinds 
    CHECK_RESULT $? 0 0 "hwloc-ls --cpukinds failed"
    hwloc-ls --memattrs | grep "Memory attribute "
    CHECK_RESULT $? 0 0 "hwloc-ls --mematters failed"
    hwloc-ls --no-smt | grep "PU"
    CHECK_RESULT $? 1 0 "hwloc-ls --no-smt failed"
    hwloc-ls --filter Core:all | grep "Core"
    CHECK_RESULT $? 0 0 "hwloc-ls --filter <type> failed"
    hwloc-ls --filter Core:none | grep "Core"
    CHECK_RESULT $? 1 0 "hwloc-ls --filter <type> failed"
    hwloc-ls --disallowed | grep "Package"
    CHECK_RESULT $? 0 0 "hwloc-ls --disallowed failed"
    hwloc-ls --allow local | grep "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --allow failed"
    hwloc-ls -p --flags 2 | grep "Core"
    CHECK_RESULT $? 0 0 "hwloc-ls --flags <n> failed"
    hwloc-ls out.xml --distances && ls | grep "out.xml"
    CHECK_RESULT $? 0 0 "hwloc-ls --distances failed"
    hwloc-ls -l --distances-transform links | grep "PU"
    CHECK_RESULT $? 0 0 "hwloc-ls --distances-transform failed"
    hwloc-ls -h | grep "Usage: hwloc-ls"
    CHECK_RESULT $? 0 0 "hwloc-ls -h failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rd out.xml
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
