#!/usr/bin/bash
  
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linmengmeng
#@Contact       :   linmengmeng@huawei.com
#@Date          :   2024-11-16
#@License       :   Mulan PSL v2
#@Desc          :    dbus-broker test
#####################################
source "${OET_PATH}/testcases/smoke-test/smoke-dbus-broker/common/common_dbus_broker.sh"

function pre_test() {
    # make sure NetworkManager active before test
    if ! systemctl is-active NetworkManager; then
        systemctl restart NetworkManager
        check_status "NetworkManager" 1 10 || exit 1
    fi
}

function run_test() {
    systemctl status dbus | grep 'Main PID' | grep dbus-daemon || exit 1
    systemctl status dbus | grep 'Loaded' | grep '/usr/lib/systemd/system/dbus.service' || exit 1
    ps aux | grep -v grep | grep -v mugen | grep dbus-broker && exit 1
    systemctl is-enabled dbus |& grep static || exit 1

    # install dbus-broker
    DNF_INSTALL dbus-broker
    CHECK_RESULT $? 0 0 'dbus-broker is install success'
    systemctl status dbus | grep 'Main PID' | grep dbus-daemon
    CHECK_RESULT $? 0 0 'dbus-broker is install success'
    systemctl status dbus | grep 'Loaded' | grep '/usr/lib/systemd/system/dbus-broker.service'
    CHECK_RESULT $? 0 0 'dbus-broker is install success'
    ps aux | grep -v grep | grep -v mugen | grep dbus-broker && exit 1
    ls /usr/lib/systemd/system/dbus.service
    CHECK_RESULT $? 0 0
    systemctl is-enabled dbus |& grep alias
    CHECK_RESULT $? 0 0

    # remove dbus-broker directly
    DNF_REMOVE "$@"
    # dbus start, NetworkManager inactive
    systemctl start dbus
    sleep 10
    systemctl is-active NetworkManager |& grep inactive
    CHECK_RESULT $? 0 0
    systemctl status dbus | grep 'Main PID' | grep dbus-daemon
    CHECK_RESULT $? 0 0
    systemctl status dbus | grep 'Loaded' | grep '/usr/lib/systemd/system/dbus.service'
    CHECK_RESULT $? 0 0
    ps aux | grep -v grep | grep -v mugen | grep dbus-broker
    CHECK_RESULT $? 0 1
    systemctl is-enabled dbus |& grep static
    CHECK_RESULT $? 0 0

}

function post_test() {
    LOG_INFO "test end"
    DNF_REMOVE "$@"
}

main "$@"
