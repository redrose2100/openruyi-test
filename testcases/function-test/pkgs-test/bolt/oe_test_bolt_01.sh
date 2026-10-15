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
# @Date      :   2025-08-21
# @License   :   Mulan PSL v2
# @Desc      :   bolt command testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "bolt"
    systemctl start bolt.service  
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."
    LOG_INFO " Verify bolt command line tool"
    boltctl --version |grep -iq "bolt"
    CHECK_RESULT $? 0 0 "bolt command not working"

    LOG_INFO " Verify service logging"
    journalctl -u bolt.service  | grep -iq "started"
    CHECK_RESULT $? 0 0 "Service start log not found"

    LOG_INFO "Check DBus interface"
    busctl list | grep -q bolt
    CHECK_RESULT $? 0 0 "DBus interface not available"

    LOG_INFO "Verify security policy"
    test -f /usr/share/dbus-1/system.d/org.freedesktop.bolt.conf
    CHECK_RESULT $? 0 0 "DBus policy file missing"
    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop bolt.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
