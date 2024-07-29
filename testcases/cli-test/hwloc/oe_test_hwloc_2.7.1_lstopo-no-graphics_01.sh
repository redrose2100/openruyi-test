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
#@Desc      :   Test lstopo-no-graphics
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
    lstopo-no-graphics --cpukinds
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --cpukinds failed"
    lstopo-no-graphics --memattrs | grep "Memory attribute "
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --memattrs failed"
    lstopo-no-graphics --no-smt | grep "PU"
    CHECK_RESULT $? 1 0 "lstopo-no-graphics --no-smt failed"
    lstopo-no-graphics --filter Core:all | grep "Core"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --filter failed"
    lstopo-no-graphics --filter Core:none | grep "Core"
    CHECK_RESULT $? 1 0 "lstopo-no-graphics --filter failed"
    lstopo-no-graphics --disallowed | grep "Package"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --disallowed failed"
    lstopo-no-graphics --allow local | grep "PU"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --allow failed"
    lstopo-no-graphics -p --flags 2 | grep "Core"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --flags <n> failed"
    lstopo-no-graphics out.xml --distances && [ -e "out.xml" ]
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --distances failed"
    lstopo-no-graphics -l --distances-transform links | grep "PU"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics --distances-transform failed"
    lstopo-no-graphics -h | grep "Usage: lstopo-no-graphics"
    CHECK_RESULT $? 0 0 "lstopo-no-graphics -h failed "
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf out.xml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
