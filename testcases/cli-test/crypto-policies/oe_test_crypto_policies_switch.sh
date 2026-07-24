#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/17
# @License   :   Mulan PSL v2
# @Desc      :   Test crypto-policies switching and policy application verification
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "crypto-policies"
    ORIGINAL_POLICY=$(update-crypto-policies --show)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test --help option
    update-crypto-policies --help | grep -qi "Usage:"
    CHECK_RESULT $? 0 0 "update-crypto-policies --help failed"

    # Test --set option: switch to LEGACY policy
    update-crypto-policies --set LEGACY
    CHECK_RESULT $? 0 0 "update-crypto-policies --set LEGACY failed"
    # Verify policy is set
    update-crypto-policies --show | grep -q "^LEGACY$"
    CHECK_RESULT $? 0 0 "Failed to set LEGACY policy"
    # Verify --is-applied returns success
    update-crypto-policies --is-applied
    CHECK_RESULT $? 0 0 "LEGACY policy not applied"
    [ -f "/etc/crypto-policies/back-ends/openssl.config" ]
    CHECK_RESULT $? 0 0 "OpenSSL backend config not found"

    # Test --set option: switch to DEFAULT policy
    update-crypto-policies --set DEFAULT
    CHECK_RESULT $? 0 0 "update-crypto-policies --set DEFAULT failed"
    update-crypto-policies --show | grep -q "^DEFAULT$"
    CHECK_RESULT $? 0 0 "Failed to set DEFAULT policy"
    update-crypto-policies --is-applied
    CHECK_RESULT $? 0 0 "DEFAULT policy not applied"

    # Test --set option: switch to FUTURE policy
    update-crypto-policies --set FUTURE
    CHECK_RESULT $? 0 0 "update-crypto-policies --set FUTURE failed"
    update-crypto-policies --show | grep -q "^FUTURE$"
    CHECK_RESULT $? 0 0 "Failed to set FUTURE policy"
    update-crypto-policies --is-applied
    CHECK_RESULT $? 0 0 "FUTURE policy not applied"

    # Test sub-policy: DEFAULT:NO-SHA1
    update-crypto-policies --set DEFAULT:NO-SHA1
    CHECK_RESULT $? 0 0 "update-crypto-policies --set DEFAULT:NO-SHA1 failed"
    update-crypto-policies --show | grep -q "^DEFAULT:NO-SHA1$"
    CHECK_RESULT $? 0 0 "Failed to set DEFAULT:NO-SHA1 policy"

    # Test --no-check option: skip checks when switching policy
    update-crypto-policies --set DEFAULT --no-check
    CHECK_RESULT $? 0 0 "update-crypto-policies --set DEFAULT --no-check failed"

    # Test --no-reload option: skip reload when switching policy
    update-crypto-policies --set LEGACY --no-reload
    CHECK_RESULT $? 0 0 "update-crypto-policies --set LEGACY --no-reload failed"

    # Test invalid policy name
    update-crypto-policies --set INVALID_POLICY
    CHECK_RESULT $? 0 1 "update-crypto-policies should fail with invalid policy"

    # Test policy application verification: check backend config files exist
    [ -f "/etc/crypto-policies/back-ends/openssl.config" ]
    CHECK_RESULT $? 0 0 "OpenSSL backend config not found"
    [ -f "/etc/crypto-policies/back-ends/openssh.config" ]
    CHECK_RESULT $? 0 0 "OpenSSH backend config not found"
    [ -f "/etc/crypto-policies/back-ends/gnutls.config" ]
    CHECK_RESULT $? 0 0 "GnuTLS backend config not found"

    # Test state file existence
    [ -f "/etc/crypto-policies/state/CURRENT.pol" ]
    CHECK_RESULT $? 0 0 "CURRENT.pol state file not found"

    # Test policy detail config files existence
    [ -f "/usr/share/crypto-policies/policies/DEFAULT.pol" ]
    CHECK_RESULT $? 0 0 "DEFAULT.pol policy file not found"
    [ -f "/usr/share/crypto-policies/policies/LEGACY.pol" ]
    CHECK_RESULT $? 0 0 "LEGACY.pol policy file not found"
    [ -f "/usr/share/crypto-policies/policies/FUTURE.pol" ]
    CHECK_RESULT $? 0 0 "FUTURE.pol policy file not found"

    # Test sub-policy file existence
    [ -f "/usr/share/crypto-policies/policies/modules/NO-SHA1.pmod" ]
    CHECK_RESULT $? 0 0 "NO-SHA1.pmod subpolicy file not found"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ -n "${ORIGINAL_POLICY}" ]; then
        update-crypto-policies --set "${ORIGINAL_POLICY}"
    fi
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
