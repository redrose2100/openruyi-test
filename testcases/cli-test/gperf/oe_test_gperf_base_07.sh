#!/usr/bin/bash

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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL gperf
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gperf -r ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -r failed."
    gperf --random ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --random failed."
    gperf -s'2' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -s failed."
    gperf --size-multiple='2' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --size-multiple failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "End to restore the test environment."
}

main $@
