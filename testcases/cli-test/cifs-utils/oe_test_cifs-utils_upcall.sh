#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-08-03
# @License   :   Mulan PSL v2
# @Desc      :   Test cifs.upcall command - CIFS upcall helper for Kerberos
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "cifs-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test command_exists: Verify cifs.upcall command is available
    which cifs.upcall > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifs.upcall command not found"

    # Test no_args: Show usage when no arguments provided
    cifs.upcall 2>&1 | grep "Usage:" > /dev/null
    CHECK_RESULT $? 0 0 "cifs.upcall usage not displayed"

    # Test -v: Show version
    cifs.upcall -v 2>&1 | grep "version" > /dev/null
    CHECK_RESULT $? 0 0 "cifs.upcall -v version display failed"

    # Test -t: Fail without key_serial
    cifs.upcall -t > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifs.upcall -t should fail without key_serial"

    # Test -E: Fail without key_serial
    cifs.upcall -E > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifs.upcall -E should fail without key_serial"

    # Test -l: Fail without key_serial
    cifs.upcall -l > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifs.upcall -l should fail without key_serial"

    # Test -e: Fail without key_serial
    cifs.upcall -e 3600 > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifs.upcall -e should fail without key_serial"

    # Test -K: Fail without key_serial
    cifs.upcall -K /etc/krb5.keytab > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifs.upcall -K should fail without key_serial"

    # Test -k: Fail without key_serial
    cifs.upcall -k /etc/krb5.conf > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifs.upcall -k should fail without key_serial"

    # Test invalid_option: Invalid option produces error
    cifs.upcall --invalid 2>&1 | grep -i "invalid" > /dev/null
    CHECK_RESULT $? 0 0 "cifs.upcall invalid option should fail"

    # Test config_file: Verify config file exists
    [ -f "/etc/request-key.d/cifs.spnego.conf" ]
    CHECK_RESULT $? 0 0 "cifs.upcall config file missing"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
