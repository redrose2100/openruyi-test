#!/usr/bin/bash
source ${OET_PATH}/libs/locallibs/common_lib.sh
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mpich command
# ############################################

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL gperf
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gperf -D ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -D failed."
    gperf --duplicates ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --duplicates failed."
    gperf -m'ITERATIONS' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -m failed."
    gperf --multiple-iterations='ITERATIONS' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --multiple-iterations failed."
    gperf -i'1' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -i failed."
    gperf --initial-asso='1' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --initial-asso failed."
    gperf -j '10' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -j failed."
    gperf --jump='10' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --jump failed."
    gperf -n ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -n failed."
    gperf --no-strlen ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --no-strlen failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment. "
}

main $@
