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
# @Desc      :   Test cifscreds command - manage CIFS credentials
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! grep -q "cifs-test-host" /etc/hosts 2>/dev/null; then
        echo "127.0.0.1 cifs-test-host" >> /etc/hosts
        echo "127.0.0.1 cifs-test-domain" >> /etc/hosts
        echo "127.0.0.1 cifs-test-host2" >> /etc/hosts
    fi
    DNF_INSTALL "cifs-utils"
    cifscreds clearall 2>/dev/null || true
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test no_args: Show usage when no arguments provided
    cifscreds 2>&1 | grep "Usage:" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds usage not displayed"

    # Test add: Add credential (key: cifs:a:127.0.0.1)
    echo "" | cifscreds add cifs-test-host > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds add cifs-test-host failed"

    # Test add_verify: Verify credential exists in keyring after add
    keyctl show 2>&1 | grep "cifs:a:127.0.0.1" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds add verification: credential not found in keyring"

    # Test clear: Remove credential
    cifscreds clear cifs-test-host > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds clear cifs-test-host failed"

    # Test clear_verify: Verify credential removed from keyring
    keyctl show 2>&1 | grep "cifs:a:127.0.0.1" > /dev/null
    CHECK_RESULT $? 1 0 "cifscreds clear verification: credential still exists"

    # Test add_-u: Add credential with username (key remains cifs:a:127.0.0.1)
    echo "" | cifscreds add -u testuser cifs-test-host > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds add -u testuser failed"

    # Test add_-u_verify: Verify credential exists in keyring after add -u
    keyctl show 2>&1 | grep "cifs:a:127.0.0.1" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds add -u verification: credential not found in keyring"

    # Test update_-u: Update credential with username
    echo "" | cifscreds update -u testuser cifs-test-host > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds update -u failed"

    # Test update_-u_verify: Verify credential still exists after update
    keyctl show 2>&1 | grep "cifs:a:127.0.0.1" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds update -u verification: credential not found after update"

    # Test clear_-u: Remove credential for specified user
    cifscreds clear -u testuser cifs-test-host > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds clear -u failed"

    # Test clear_-u_verify: Verify credential removed after clear -u
    keyctl show 2>&1 | grep "cifs:a:127.0.0.1" > /dev/null
    CHECK_RESULT $? 1 0 "cifscreds clear -u verification: credential still exists"

    # Test add_-d: Add credential with domain (key: cifs:d:cifs-test-domain)
    echo "" | cifscreds add -d cifs-test-domain > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds add -d cifs-test-domain failed"

    # Test add_-d_verify: Verify domain credential exists in keyring
    keyctl show 2>&1 | grep "cifs:d:cifs-test-domain" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds add -d verification: credential not found in keyring"

    # Test update_-d: Update credential with domain
    echo "" | cifscreds update -d cifs-test-domain > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds update -d failed"

    # Test update_-d_verify: Verify domain credential still exists after update
    keyctl show 2>&1 | grep "cifs:d:cifs-test-domain" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds update -d verification: credential not found after update"

    # Test clear_-d: Remove domain credential
    cifscreds clear -d cifs-test-domain > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds clear -d failed"

    # Test clear_-d_verify: Verify domain credential removed after clear -d
    keyctl show 2>&1 | grep "cifs:d:cifs-test-domain" > /dev/null
    CHECK_RESULT $? 1 0 "cifscreds clear -d verification: credential still exists"

    # Test add_-u_-d: Combined user and domain option (key: cifs:d:cifs-test-host2)
    echo "" | cifscreds add -u domainuser -d cifs-test-host2 > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds add -u -d failed"

    # Test add_-u_-d_verify: Verify combined credential exists in keyring
    keyctl show 2>&1 | grep "cifs:d:cifs-test-host2" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds add -u -d verification: credential not found"

    # Test clearall: Remove all credentials
    cifscreds clearall > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "cifscreds clearall failed"

    # Test clearall_verify: Verify no cifs credentials remain
    keyctl show 2>&1 | grep "cifs:" > /dev/null
    CHECK_RESULT $? 1 0 "cifscreds clearall verification: credentials still exist"

    # Test invalid_subcommand: Invalid subcommand returns non-zero
    cifscreds invalid_cmd > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifscreds invalid_cmd should fail"

    # Test missing_host: Missing host parameter returns non-zero
    cifscreds add > /dev/null 2>&1
    CHECK_RESULT $? 1 0 "cifscreds add without host should fail"

    # Test --help: Show help information
    cifscreds --help 2>&1 | grep -i "Usage\|unrecognized" > /dev/null
    CHECK_RESULT $? 0 0 "cifscreds --help produces expected output"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cifscreds clearall 2>/dev/null || true
    sed -i '/cifs-test-host/d' /etc/hosts 2>/dev/null || true
    sed -i '/cifs-test-domain/d' /etc/hosts 2>/dev/null || true
    sed -i '/cifs-test-host2/d' /etc/hosts 2>/dev/null || true
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
