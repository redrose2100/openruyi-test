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

    papi_native_avail --iarr | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --iarr failed"

    papi_native_avail --iear | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --iear failed"

    papi_native_avail --opcm | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --opcm failed"

    papi_native_avail --nogroups | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --nogroups failed"

    papi_multiplex_cost -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "Check papi_multiplex_cost -h failed"

    papi_multiplex_cost -m 200 -x 200 -t max -s 2>&1 | grep "This utility b"
    CHECK_RESULT $? 0 0 "Check papi_multiplex_cost -m -x -t -s failed"

    papi_multiplex_cost -m 200 -x 200 -t max -k 2>&1 | grep "This utility b"
    CHECK_RESULT $? 0 0 "Check papi_multiplex_cost -m -x -t -k failed"

    papi_error_codes | grep "Error code"
    CHECK_RESULT $? 0 0 "Check papi_error_codes failed"

    papi_mem_info | grep "Cache Information"
    CHECK_RESULT $? 0 0 "Check papi_mem_info failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
