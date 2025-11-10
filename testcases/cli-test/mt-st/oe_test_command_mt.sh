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
# @Date      :   2025-11-10
# @License   :   Mulan PSL v2
# @Desc      :   mt command testing
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "mt-st mt-st-help"
    cp /usr/share/doc/mt-st-help/stinit.def.examples /etc/stinit.def
    systemctl start stinit.service
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO "Test 1: Verify mt command availability"
    which mt >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "mt command not available"
    LOG_INFO "Test 2: Verify configuration file syntax"
    stinit -f /etc/stinit.def -p >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "stinit configuration file syntax error"
    LOG_INFO "Test 3: Test mt command basic functionality"
    mt -h >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "mt command help check failed"
    LOG_INFO "Test 4: Verify help documentation"
    man -w mt >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "mt command manual page missing"
    LOG_INFO "Test 5: Verify mt command version"
    mt --version >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "mt command version check failed"
    LOG_INFO "Test 6: Verify service dependencies"
    systemctl list-dependencies stinit.service | grep -q "sysinit.target"
    CHECK_RESULT $? 0 0 "Service dependencies incorrect"
    LOG_INFO "Test 7: Verify service logging"
    journalctl -u stinit.service  | grep  -iq "finished"
    CHECK_RESULT $? 0 0 "Service logging not working"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop stinit.service
    rm -rf /etc/stinit.def
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
