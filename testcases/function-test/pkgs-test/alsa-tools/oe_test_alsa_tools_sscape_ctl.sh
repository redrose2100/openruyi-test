#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/29
# @License   :   Mulan PSL v2
# @Desc      :   Test sscape_ctl command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools alsa-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test --help option
    sscape_ctl --help 2>&1 | grep -i "\-\-help"
    CHECK_RESULT $? 0 0 "sscape_ctl --help check failed"
    # Test --version option
    sscape_ctl --version | grep -i "v0.1"
    CHECK_RESULT $? 0 0 "sscape_ctl --version check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test --card option
        sscape_ctl --card 0 2>&1 | grep -i "sscape\|card"
        CHECK_RESULT $? 0 0 "sscape_ctl --card option check failed"
        # Test --directory option
        sscape_ctl --directory /usr/share/sounds 2>&1 | grep -i "sscape\|directory"
        CHECK_RESULT $? 0 0 "sscape_ctl --directory option check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
