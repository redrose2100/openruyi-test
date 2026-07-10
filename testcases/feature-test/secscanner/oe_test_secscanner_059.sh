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
# @Date      :   2026-3-31
# @License   :   Mulan PSL v2
# @Desc      :   forbidden_to_su=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SU_FILE="/etc/pam.d/su"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi

    # Backup su file
    if [[ -f "$SU_FILE" && ! -f "${SU_FILE}-bak" ]]; then
        \cp "$SU_FILE" "${SU_FILE}-bak"
    fi

    # Remove any existing pam_wheel configuration
    sed -i '/auth.*pam_wheel\.so/d' "$SU_FILE"

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set forbidden_to_su=no in secscanner.cfg
    sed -i 's/^forbidden_to_su.*/forbidden_to_su=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set forbidden_to_su=no"

    # Step 2: Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check

    # Step 3: Execute secscanner fix basic and check configuration
    secscanner fix basic > tmp && \mv tmp fix
    # When forbidden_to_su=no, pam_wheel configuration should remain unchanged
    grep -E "^auth\s+required\s+pam_wheel\.so\s+(group=wheel\s+)?use_uid" "$SU_FILE"
    CHECK_RESULT $? 1 0 "Step 4: pam_wheel configuration should remain"
    secscanner restore all -y> tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    if [[ -f "${SU_FILE}-bak" ]]; then
        \cp "${SU_FILE}-bak" "$SU_FILE"
    fi

    # Remove installed packages
    DNF_REMOVE

    # Clean up temporary files
    rm -f fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
