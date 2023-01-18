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
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of papi command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL papi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    papi_avail 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail failed"

    papi_avail -h 2>&1 | grep "This is the PAPI avail program"
    CHECK_RESULT $? 0 0 "Check papi_avail -h failed"

    papi_avail --avail 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail --avail failed"

    papi_avail -a 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail -a failed"

    papi_avail -c 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail -c failed"

    papi_avail --check 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail --check failed"

    papi_avail -d 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail -d failed"

    papi_avail --detail 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail --detail failed"

    papi_avail -e PAPI_TLB_DM | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail -e PAPI_TLB_DM failed"

    papi_avail --br 2>&1 | grep "Available PAPI"
    CHECK_RESULT $? 0 0 "Check papi_avail --br failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
