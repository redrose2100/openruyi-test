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
# @Author    :   kangjiangbo
# @Contact   :   kangjiangbo_yewu@cmss.chinamobile.com
# @Date      :   2026-4-1
# @License   :   Mulan PSL v2
# @Desc      :   password complexity test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SYSTEM_AUTH_FILE="/etc/pam.d/system-auth"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SYSTEM_AUTH_FILE" && ! -f "${SYSTEM_AUTH_FILE}-bak" ]]; then
        \cp "$SYSTEM_AUTH_FILE" "${SYSTEM_AUTH_FILE}-bak"
        LOG_INFO "Backed up /etc/pam.d/system-auth"
    fi
    sed -i '/pam_pwquality.so/d' "$SYSTEM_AUTH_FILE"
    sed -i '/pam_cracklib.so/d' "$SYSTEM_AUTH_FILE"
    LOG_INFO "Removed existing password complexity configurations"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_passComplex=yes in secscanner.cfg
    sed -i 's/^set_passComplex.*/set_passComplex=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_passComplex=yes"
    # Execute secscanner check level3 before fix
    secscanner check level3 > tmp && \mv tmp check
    grep -i "password" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
    # Execute secscanner fix level3 and check system-auth content
    secscanner fix level3 > tmp && \mv tmp fix
    # Check password complexity configuration
    grep -E "password\s+requisite\s+pam_pwquality\.so\s+try_first_pass\s+local_users_only\s+retry=3\s+difok=3\s+minclass=4\s+minlen=10\s+ucredit=-1\s+lcredit=-1\s+dcredit=-1\s+ocredit=-1\s+enforce_for_root" "$SYSTEM_AUTH_FILE"
    CHECK_RESULT $? 0 0 "Step 3: pam_pwquality.so not configured correctly"
    # Check that pam_pwquality.so and pam_cracklib.so are not used simultaneously
    grep -E "pam_cracklib\.so" "$SYSTEM_AUTH_FILE"
    CHECK_RESULT $? 1 0 "Step 4: pam_cracklib.so should not be used"
    # Debug: Show current password complexity configuration
    LOG_INFO "Current password complexity configuration:"
    grep -i "pam_pwquality\|pam_cracklib" "$SYSTEM_AUTH_FILE"
    # Execute secscanner check level3 and check output
    secscanner check level3 > tmp && \mv tmp check
    grep -i "Password MinLen" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 5: Password MinLen check not found"
    grep -i "Password Minclass" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 5: Password Minclass check not found"
    grep -i "Password ucredit" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 5: Password ucredit check not found"
    grep -i "Password lcredit" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 5: Password lcredit check not found"
    grep -i "Password dcredit" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 5: Password dcredit check not found"
    grep -i "Password ocredit" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 5: Password ocredit check not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/pam.d/system-auth" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 6: Restore message not found"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${SYSTEM_AUTH_FILE}-bak" ]]; then
        \cp "${SYSTEM_AUTH_FILE}-bak" "$SYSTEM_AUTH_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

