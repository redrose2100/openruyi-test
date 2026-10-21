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
# @Date      :   2025-09-08
# @License   :   Mulan PSL v2
# @Desc      :   numad command testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL numad
    systemctl start numad.service
    sleep 2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Test 2: Verify process running status"
    pgrep -x numad >/dev/null
    CHECK_RESULT $? 0 0 "numad process not running"

    LOG_INFO "Test 3: Verify logging functionality"
    journalctl -u numad.service | grep -iq "Started numad"
    CHECK_RESULT $? 0 0 "Service logging not working"

    LOG_INFO "Test 4: Verify version information"
    numad -V | grep -iq "numad version"
    CHECK_RESULT $? 0 0 "Version information not available"

    LOG_INFO "Test 5: Verify verbose mode"
    numad -v -i 1:2 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Verbose mode test failed"

    LOG_INFO "Test 6: Verify debug mode"
    numad -d -i 1:2 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Debug mode test failed"

    LOG_INFO "Test 7: Verify interval setting"
    numad -i 5:10 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Interval setting test failed"

    LOG_INFO "Test 8: Verify memory locality target"
    numad -m 80 -i 1:2 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Memory locality target test failed"

    LOG_INFO "Test 9: Verify CPU reservation"
    numad -R 0 -i 1:2 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "CPU reservation test failed"

    LOG_INFO "Test 10: Verify NUMA node suggestions"
    numad -w 0:1024 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "NUMA node suggestions test failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop numad.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
