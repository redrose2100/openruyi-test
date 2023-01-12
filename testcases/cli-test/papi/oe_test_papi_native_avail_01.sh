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

    papi_native_avail -h 2>&1 | grep "Usage: papi_native_avail"
    CHECK_RESULT $? 0 0 "Check papi_native_avail -h failed"

    papi_native_avail --help 2>&1 | grep "Usage: papi_native_avail"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --help failed"

    papi_native_avail -c | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail -c failed"

    papi_native_avail --check | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --check failed"

    papi_native_avail -e PAPI_REF_CYC | grep "PAPI_REF_CYC"
    CHECK_RESULT $? 0 0 "Check papi_native_avail -e failed"

    papi_native_avail -i PAPI_REF_CYC | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail -i failed"

    papi_native_avail -x PAPI_REF_CYC | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail -x failed"

    papi_native_avail --noqual | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --noqual failed"

    papi_native_avail --darr | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --darr failed"

    papi_native_avail --dear | grep "Total events"
    CHECK_RESULT $? 0 0 "Check papi_native_avail --dear failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
