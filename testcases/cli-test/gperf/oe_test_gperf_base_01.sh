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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gperf --help 2>&1 | grep "GNU 'gperf' generates"
    CHECK_RESULT $? 0 0 "Check '--help  failed"
    gperf -h 2>&1 | grep "GNU 'gperf' generates"
    CHECK_RESULT $? 0 0 "Check gperf -h failed."
    gperf --version 2>&1 | grep $(rpm -q gperf --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check gperf --version failed."
    gperf -v 2>&1 | grep $(rpm -q gperf --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check gperf -v failed."
    gperf --debug --delimiters ',' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -d failed."
    gperf -d -e ',' ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -d -e failed."
    gperf --delimiters=',' common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --delimiters failed."
    gperf -t ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf -t failed."
    gperf --struct-type ./common/test.gperf
    CHECK_RESULT $? 0 0 "Check gperf --struct-type failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "Eed to restore the test environment."
}

main $@
