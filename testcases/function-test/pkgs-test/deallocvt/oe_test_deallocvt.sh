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
#@Date          :   2026-06-09
#@License       :   Mulan PSL v2
#@Desc          :   Test case for deallocvt command
#####################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "kbd"
    test -f /usr/bin/deallocvt
    CHECK_RESULT $? 0 0 "deallocvt binary not found at expected path /usr/bin/deallocvt"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test help option
    deallocvt --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "deallocvt --help failed to execute correctly"

    # Test default run: deallocate all unused virtual terminals
    deallocvt > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "deallocvt default execution (deallocate unused VTs) failed"

    # Test invalid VT number: should return error
    deallocvt 999 2>/dev/null
    CHECK_RESULT $? 0 1 "deallocvt with invalid VT number did not return expected error"

    # Test deallocate active VT: should fail
    current_vt=$(tty | grep -oE '[0-9]+$')
    if [ -n "$current_vt" ]; then
        deallocvt "$current_vt" 2>/dev/null
        CHECK_RESULT $? 0 1 "deallocvt on active VT did not return expected error"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
