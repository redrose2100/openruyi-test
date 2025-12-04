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
# @Date      :   2025-12-02
# @License   :   Mulan PSL v2
# @Desc      :   munge command testi
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL munge
    create-munge-key 2>/dev/null || dd if=/dev/urandom of=/etc/munge/munge.key bs=1 count=1024 2>/dev/null
    chmod 0700 /etc/munge
    chmod 0711 /var/lib/munge
    chmod 0700 /var/log/munge
    chmod 0600 /etc/munge/munge.key
    chown munge:munge /etc/munge/munge.key
    systemctl start munge.service
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."

    LOG_INFO "Test 1: Verify munge key file existence"
    test -f /etc/munge/munge.key
    CHECK_RESULT $? 0 0 "munge.key file missing"

    LOG_INFO "Test 2: Verify munge key file permissions"
    stat -c %a /etc/munge/munge.key | grep -q "^600$"
    CHECK_RESULT $? 0 0 "munge.key file permissions incorrect (should be 600)"

    LOG_INFO "Test 3: Verify munge user and group"
    id munge >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "munge user does not exist"

    LOG_INFO "Test 4: Verify munge authentication functionality"
    munge -n | unmunge 2>&1 | grep -q "STATUS:"
    CHECK_RESULT $? 0 0 "munge authentication test failed"

    LOG_INFO "Test 5: Verify munge encryption functionality"
    echo "test" | munge | unmunge 2>&1 | grep -q "test"
    CHECK_RESULT $? 0 0 "munge encryption/decryption test failed"

    LOG_INFO "Test 6: Verify munge process running status"
    pgrep -u munge munged >/dev/null
    CHECK_RESULT $? 0 0 "munged process not running"

    LOG_INFO "Test 7: Verify munge socket file"
    test -S /var/run/munge/munge.socket.2
    CHECK_RESULT $? 0 0 "munge socket file missing"

    LOG_INFO "Test 8: Verify munge version information"
    munge --version >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "munge version check failed"
 
    LOG_INFO "Test 9: Verify remunge command"
    which remunge >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "remunge command not available"

    LOG_INFO "Test 10: Verify munge logging"
    test -d /var/log/munge
    CHECK_RESULT $? 0 0 "munge log directory missing"

    LOG_INFO "Test 11: Verify munge service port"
    netstat -tuln | grep -q ":.*munge" 2>/dev/null
    CHECK_RESULT $? 0 1 "munge service port check"

    LOG_INFO "Test 12: Verify service dependencies"
    systemctl list-dependencies munge.service | grep -q "sysinit.target"
    CHECK_RESULT $? 0 0 "Service dependencies incorrect"

    LOG_INFO "Test 13: Verify munge key reload capability"
    killall -HUP munged 2>/dev/null && sleep 1 && systemctl is-active munge.service
    CHECK_RESULT $? 0 0 "munge key reload test failed"

    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop munge.service
    rm -rf /etc/munge/munge.key
    rm -f /var/run/munge/munge.socket*
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
