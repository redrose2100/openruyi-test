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
# @Desc      :   set_bashrc_alias=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
BASHRC_FILE="/root/.bashrc"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    # Check if secScanner is installed
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi

    # Backup bashrc file
    if [[ -f "$BASHRC_FILE" && ! -f "${BASHRC_FILE}-bak" ]]; then
        \cp "$BASHRC_FILE" "${BASHRC_FILE}-bak"
    fi

    # Remove existing aliases for testing
    sed -i '/alias ls=.*/d' "$BASHRC_FILE"
    sed -i '/alias rm=.*/d' "$BASHRC_FILE"
    LOG_INFO "Removed existing aliases for testing"

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_bashrc_alias=no in secscanner.cfg
    sed -i 's/^set_bashrc_alias.*/set_bashrc_alias=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_bashrc_alias=no"

    # Step 3: Execute secscanner fix basic and check bashrc content
    secscanner fix basic > tmp && \mv tmp fix
    # When set_bashrc_alias=no, aliases should not be added
    grep -E "alias ls='ls -al'" "$BASHRC_FILE"
    CHECK_RESULT $? 1 0 "Step 3: alias ls should not be added"
    grep -E "alias rm='rm -i'" "$BASHRC_FILE"
    CHECK_RESULT $? 1 0 "Step 3: alias rm should not be added"

    # Step 6: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    if [[ -f "${BASHRC_FILE}-bak" ]]; then
        \cp "${BASHRC_FILE}-bak" "$BASHRC_FILE"
    fi

    # Remove installed packages
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f fix check restore tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
