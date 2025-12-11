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
# @Date      :   2025-12-04
# @License   :   Mulan PSL v2
# @Desc      :   haveged command test
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL haveged
    systemctl start haveged.service
    sleep 2
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."

    LOG_INFO "Test 1: Verify haveged process running status"
    pgrep -x haveged >/dev/null
    CHECK_RESULT $? 0 0 "haveged process not running"

    LOG_INFO "Test 2: Verify entropy pool monitoring"
    cat /proc/sys/kernel/random/entropy_avail >/dev/null
    CHECK_RESULT $? 0 0 "Entropy pool monitoring failed"

    LOG_INFO "Test 3: Verify entropy generation functionality"
    initial_entropy=$(cat /proc/sys/kernel/random/entropy_avail)
    sleep 1
    current_entropy=$(cat /proc/sys/kernel/random/entropy_avail)
    [ "$current_entropy" -ge "$initial_entropy" ]
    CHECK_RESULT $? 0 0 "Entropy generation not working"

    LOG_INFO "Test 4: Verify haveged version information"
    haveged --version >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "haveged version check failed"

    LOG_INFO "Test 5: Verify service logging"
    journalctl -u haveged.service | grep -iq "success"
    CHECK_RESULT $? 0 0 "Service logging not working"

    LOG_INFO "Test 6: Verify random device access"
    dd if=/dev/random of=/dev/null bs=1 count=1 2>/dev/null
    CHECK_RESULT $? 0 0 "Random device access failed"


    LOG_INFO "Test 7: Verify urandom device access"
    dd if=/dev/urandom of=/dev/null bs=1024 count=1 2>/dev/null
    CHECK_RESULT $? 0 0 "Urandom device access failed"

    LOG_INFO "Test 8: Verify service dependencies"
    systemctl list-dependencies haveged.service | grep -q "sysinit.target"
    CHECK_RESULT $? 0 0 "Service dependencies incorrect"

    LOG_INFO "Test 9: Verify service recovery capability"
    systemctl restart haveged.service && sleep 1 && systemctl is-active haveged.service
    CHECK_RESULT $? 0 0 "Service recovery test failed"

    LOG_INFO "Test 10: Verify help documentation"
    haveged --help 2>&1 | head -5 | grep -q "haveged"
    CHECK_RESULT $? 0 0 "Help documentation not available"
    
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop haveged.service
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
