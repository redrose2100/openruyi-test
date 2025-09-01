#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   libeibei
# @Contact   :   libeibei@uniontech.com
# @Date      :   2025-08-29
# @License   :   Mulan PSL v2
# @Desc      :   ipwatchd command testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "ipwatchd"
    systemctl start ipwatchd.service
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."

    LOG_INFO "Test 1: Verify version information"
    ipwatchd --version 2>&1 | grep -iq "ipwatchd"
    CHECK_RESULT $? 0 0 "Version information not available"

    LOG_INFO "Test 2: Check help documentation"
    ipwatchd --help 2>&1 | grep -iq "help"
    CHECK_RESULT $? 0 0 "Help documentation not available"

    LOG_INFO "Test 3: Verify configuration file"
    test -f /etc/ipwatchd.conf
    CHECK_RESULT $? 0 0 "ipwatchd.conf configuration file missing"

    LOG_INFO "Test 4: Check logging functionality"
    journalctl -u ipwatchd.service  | grep -iq "ipwatchd started"
    CHECK_RESULT $? 0 0 "Service logging not working"

    LOG_INFO "Test 5: Verify process status"
    pgrep -x ipwatchd >/dev/null
    CHECK_RESULT $? 0 0 "ipwatchd process not running"

    LOG_INFO "Test 6: Check IP conflict detection"
    systemctl status ipwatchd.service | grep -q "detect"
    CHECK_RESULT $? 0 0 "IP conflict detection not enabled"

    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop ipwatchd.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
