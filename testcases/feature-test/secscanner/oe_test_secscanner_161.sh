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
# @Author    :   liyongqiang
# @Contact   :   liyongqiang_yewu@cmss.chinamobile.com
# @Date      :   2026-4-13
# @License   :   Mulan PSL v2
# @Desc      :   set_auditrules test (set to no, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
AUDIT_RULES_FILE="/etc/audit/rules.d/audit.rules"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install audit if not installed
    DNF_INSTALL "audit"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Create backup of audit rules file
    if [[ -f "$AUDIT_RULES_FILE" && ! -f "${AUDIT_RULES_FILE}-bak" ]]; then
        \cp "$AUDIT_RULES_FILE" "${AUDIT_RULES_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_auditrules=no in secscanner.cfg
    sed -i 's/^set_auditrules.*/set_auditrules=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_auditrules=no"
    # Step 2: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    grep -i "audit" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 2: OK message not found"
    # Step 3: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 4: Check if audit rules file remains the same
    diff "$AUDIT_RULES_FILE" "${AUDIT_RULES_FILE}-bak"
    CHECK_RESULT $? 0 0 "Step 4: Audit rules file should remain the same when set_auditrules=no"
    # Step 5: Execute secscanner restore all
    secscanner restore all -y > tmp && \mv tmp restore
    # Check if audit rules file is restored
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${AUDIT_RULES_FILE}-bak" ]]; then
        \cp "${AUDIT_RULES_FILE}-bak" "$AUDIT_RULES_FILE"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"