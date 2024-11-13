#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2024/09/23
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of augeas
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL augeas
    export AUGEAS_ROOT="./test_dir/"
    mkdir -p "$AUGEAS_ROOT/etc/"
    touch "$AUGEAS_ROOT/etc/hosts"
    LOG_INFO "End to prepare the test environment."
}

function check() {
    # check '192.168.1.101' "test1.com" "$AUGEAS_ROOT/etc/hosts" 0
    grep "$1" "$3"
    CHECK_RESULT $? "$4" 0 "content not as expected $3"
    grep "$2" "$3"
    CHECK_RESULT $? "$4" 0 "content not as expected $3" 
}

function run_test() {
    LOG_INFO "Start to run test."

    test -f "$AUGEAS_ROOT/etc/hosts"
    CHECK_RESULT $? 0 0 "$AUGEAS_ROOT/etc/hosts not exists, pre_test failed." 1
    augtool << eof
set /files/etc/hosts/01/ipaddr 192.168.1.100
set /files/etc/hosts/01/canonical test.com
save
quit
eof
    check "192.168.1.100" "test.com" "$AUGEAS_ROOT/etc/hosts" 0

    # for testing -b option
    augtool -b set /files/etc/hosts/1/ipaddr 192.168.1.101
    check "192.168.1.101" "test.com" "$AUGEAS_ROOT/etc/hosts" 0
    check "192.168.1.100" "test.com" "$AUGEAS_ROOT/etc/hosts.augsave" 0

    # for testing -n option
    augtool -n set /files/etc/hosts/1/ipaddr 192.168.1.102 
    check "192.168.1.101" "test.com" "$AUGEAS_ROOT/etc/hosts" 0
    check "192.168.1.102" "test.com" "$AUGEAS_ROOT/etc/hosts.augnew" 0

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf "$AUGEAS_ROOT"
    unset AUGEAS_ROOT
    LOG_INFO "End to restore the test environment."
}

main "$@"
