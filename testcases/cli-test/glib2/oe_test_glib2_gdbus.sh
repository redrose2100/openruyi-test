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
# @Date      :   2026/08/04
# @License   :   Mulan PSL v2
# @Desc      :   test gdbus command
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL glib2
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    dbus-daemon --session --print-address --fork > /tmp/dbus_addr_gdbus 2>/dev/null
    DBUS_SESSION_BUS_ADDRESS="$(cat /tmp/dbus_addr_gdbus)"
    export DBUS_SESSION_BUS_ADDRESS
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test gdbus help
    gdbus help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "gdbus help check failed"
    
    # Test gdbus introspect --session --dest --object-path
    gdbus introspect --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus 2>&1 | grep -i "org.freedesktop.DBus"
    CHECK_RESULT $? 0 0 "gdbus introspect --session check failed"
    
    # Test gdbus introspect --xml
    gdbus introspect --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --xml 2>&1 | grep -i "DOCTYPE node"
    CHECK_RESULT $? 0 0 "gdbus introspect --xml check failed"
    
    # Test gdbus introspect --recurse
    gdbus introspect --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --recurse 2>&1 | grep -i "node /org/freedesktop/DBus"
    CHECK_RESULT $? 0 0 "gdbus introspect --recurse check failed"
    
    # Test gdbus introspect --only-properties
    gdbus introspect --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --only-properties 2>&1 | grep -i "properties"
    CHECK_RESULT $? 0 0 "gdbus introspect --only-properties check failed"
    
    # Test gdbus call --session --dest --object-path --method
    gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.ListNames 2>&1 | grep -i "org.freedesktop.DBus"
    CHECK_RESULT $? 0 0 "gdbus call check failed"
    
    # Test gdbus call --timeout
    gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.ListNames --timeout 5 2>&1 | grep -i "org.freedesktop.DBus"
    CHECK_RESULT $? 0 0 "gdbus call --timeout check failed"
    
    # Test gdbus emit --session --object-path --signal
    gdbus emit --session --object-path /org/freedesktop/Test --signal org.freedesktop.Test.Signal1
    CHECK_RESULT $? 0 0 "gdbus emit check failed"
    
    # Test gdbus monitor --session --dest --object-path (will timeout)
    timeout 3 gdbus monitor --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus 2>&1 | grep -i "Monitoring signals"
    CHECK_RESULT $? 0 0 "gdbus monitor check failed"
    
    # Test gdbus wait --session --timeout
    timeout 3 gdbus wait --session --timeout 1 org.freedesktop.DBus
    CHECK_RESULT $? 0 0 "gdbus wait check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dbus_pid=$(pgrep -f "dbus-daemon.*session" 2>/dev/null)
    if [ -n "$dbus_pid" ]; then
        kill "$dbus_pid" 2>/dev/null
    fi
    DNF_REMOVE
    rm -f /tmp/dbus_addr_gdbus
    export LANG=$OLD_LANG
    LOG_INFO "End to restore the test environment."
}

main "$@"
