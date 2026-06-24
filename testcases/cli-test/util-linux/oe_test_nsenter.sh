#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   fuyahong
#@Contact       :   fuyahong@uniontech.com
#@Date          :   2026-06-24
#@License       :   Mulan PSL v2
#@Desc          :   Test case for nsenter command
#####################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL util-linux
    nohup sleep 60 &
    SLEEP_PID=$!
    LOG_INFO "End to prepare the test environment."
}

function run_test() {   
    LOG_INFO "Start to run test."
    # Test help option
    nsenter --help > /dev/null
    CHECK_RESULT $? 0 0 "nsenter --help execution failed"

    # Test enter UTS namespace
    nsenter -t "$SLEEP_PID" -u hostname > /dev/null
    CHECK_RESULT $? 0 0 "nsenter enter UTS namespace failed"

    # Test enter mount namespace
    nsenter -t "$SLEEP_PID" -m ls / > /dev/null
    CHECK_RESULT $? 0 0 "nsenter enter mount namespace failed"

    # Test enter all namespaces
    nsenter -t "$SLEEP_PID" -a whoami > /dev/null
    CHECK_RESULT $? 0 0 "nsenter enter all namespaces failed"

    # Test invalid target PID error handling
    nsenter -t 99999999 -a ls > /dev/null 2>&1
    CHECK_RESULT $? 0 1 "nsenter should fail with invalid PID, but succeeded"
    LOG_INFO "End to run test."
}

function post_test() {   
    LOG_INFO "Start to restore the test environment."
    if [[ -n "$SLEEP_PID" ]]; then
        kill -9 "$SLEEP_PID" > /dev/null 2>&1
        wait "$SLEEP_PID" > /dev/null 2>&1
    fi
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
