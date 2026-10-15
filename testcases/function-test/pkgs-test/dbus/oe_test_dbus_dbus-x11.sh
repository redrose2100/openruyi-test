#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2023-07-15
# @License   :   Mulan PSL v2
# @Desc      :   exrmultipart exrheader exrenvmap
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dbus dbus-x11"
    echo "b1f8d2b3dca133f611cecb5c64b643e4" >testuuid2
    vers=$(rpm -qa | grep dbus-daemon | awk -F - '{print $3}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dbus-uuidgen --help 2>&1 | grep "dbus-uuidgen"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-uuidgen
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-uuidgen --ensure=testuuid && test -f testuuid
    CHECK_RESULT $? 0 0 "Check  failed."
    echo "b1f8d2b3dca133f611cecb5c64b643e4" >testuuid2
    dbus-uuidgen --get=testuuid2 2>&1 | grep "b1f8d2b3dca133f611cecb5c64b643e4"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch -h 2>&1 | grep "dbus-launch"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --version | grep "${vers}"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch | grep "guid"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --auto-syntax | grep "export"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --binary-syntax
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --close-stderr
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --csh-syntax | grep "setenv"
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --exit-with-session
    CHECK_RESULT $? 0 0 "Check  failed."
    dbus-launch --sh-syntax | grep "export DBUS_SESSION_BUS_ADDRESS"
    CHECK_RESULT $? 0 0 "Check  failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf testuuid*
    pgrep "dbus" |xargs kill -9
    systemctl stop dbus
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
