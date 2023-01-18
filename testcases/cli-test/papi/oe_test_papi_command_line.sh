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

    papi_command_line -h 2>&1 | grep "Usage: papi_command_line"
    CHECK_RESULT $? 0 0 "Check papi_command_line -h failed"

    papi_command_line PAPI_TLB_DM -u -x | grep "PAPI_TLB_DM"
    CHECK_RESULT $? 0 0 "Check papi_command_line -u failed"

    papi_clockres | grep "PAPI_get_real_cyc"
    CHECK_RESULT $? 0 0 "Check papi_avail clockres failed"

    papi_component_avail -h 2>&1 | grep "Usage: papi_component_avail"
    CHECK_RESULT $? 0 0 "Check papi_component_avail -h failed"

    papi_component_avail --help 2>&1 | grep "Usage: papi_component_avail"
    CHECK_RESULT $? 0 0 "Check papi_component_avail --help failed"

    papi_component_avail -d | grep "net"
    CHECK_RESULT $? 0 0 "Check papi_component_avail -d failed"

    papi_cost -h 2>&1 | grep "This is the PAPI cost"
    CHECK_RESULT $? 0 0 "Check papi_cost -h failed"

    papi_decode -h 2>&1 | grep "decode [options]"
    CHECK_RESULT $? 0 0 "Check papi_decode -h failed"

    papi_decode -a | grep "PAPI_L1_DCM"
    CHECK_RESULT $? 0 0 "Check papi_decode -a failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
