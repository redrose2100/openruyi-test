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
# @Desc      :   hide_issue_info test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
ISSUE_FILE="/etc/issue"
ISSUE_NET_FILE="/etc/issue.net"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    # Check if secScanner is installed
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup issue and issue.net files
    if [[ -f "$ISSUE_FILE" && ! -f "${ISSUE_FILE}-bak" ]]; then
        \cp "$ISSUE_FILE" "${ISSUE_FILE}-bak"
    fi
    
    if [[ -f "$ISSUE_NET_FILE" && ! -f "${ISSUE_NET_FILE}-bak" ]]; then
        \cp "$ISSUE_NET_FILE" "${ISSUE_NET_FILE}-bak"
    fi

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Set hide_issue_info=yes in secscanner.cfg
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^hide_issue_info.*/hide_issue_info=yes/' "$CONFIG_FILE"

    # Check if running on a virtual machine using systemd-detect-virt
    is_vm=0
    if command -v systemd-detect-virt > /dev/null 2>&1; then
        if systemd-detect-virt > /dev/null 2>&1; then
            is_vm=1
        fi
    fi

    LOG_INFO "Is virtual machine: $is_vm"

    # Step 1: Check current status
    secscanner check basic > tmp && \mv tmp check
    if [[ $is_vm -eq 0 ]]; then
        # Not a virtual machine, should show WARNING
        grep -i "issue" check | grep WARNING
        CHECK_RESULT $? 0 0 "Issue info WARNING check failed on physical machine"
    else
        # Virtual machine, should show SKIPPED
        grep -i "issue" check | grep SKIPPED
        CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed on virtual machine"
    fi

    # Step 2: Fix the configuration
    secscanner fix basic > tmp && \mv tmp fix
    if [[ $is_vm -eq 0 ]]; then
        # Not a virtual machine, should show FINISHED
        grep -i "issue" fix | grep FINISHED
        CHECK_RESULT $? 0 0 "Issue info fix failed on physical machine"
    else
        # Virtual machine, no fix operation, so no FINISHED message
        LOG_INFO "Virtual machine, skipping fix check"
    fi

    # Step 3: Check if files were deleted (except on virtual machines)
    if [[ $is_vm -eq 0 ]]; then
        # Not a virtual machine, files should be deleted
        test -f "$ISSUE_FILE" 
        CHECK_RESULT $? 1 0 "Issue file was not deleted on physical machine"
        test -f "$ISSUE_NET_FILE" 
        CHECK_RESULT $? 1 0 "Issue.net file was not deleted on physical machine"
        LOG_INFO "SUCCESS: issue files were deleted on physical machine"
    else
        # Virtual machine, files should not be deleted
        if [[ -f "$ISSUE_FILE" && -f "$ISSUE_NET_FILE" ]]; then
            LOG_INFO "SUCCESS: issue files were not deleted on virtual machine"
        else
            LOG_INFO "ERROR: issue files were deleted on virtual machine"
            CHECK_RESULT $? 1 0 "Issue files were deleted on virtual machine"
        fi
    fi

    # Step 4: Check current status again
    secscanner check basic > tmp && \mv tmp check
    if [[ $is_vm -eq 0 ]]; then
        # Not a virtual machine, should not show WARNING
        grep -i "issue" check | grep WARNING
        CHECK_RESULT $? 0 1 "Issue info WARNING check failed after fix on physical machine"
    else
        # Virtual machine, should still show SKIPPED
        grep -i "issue" check | grep SKIPPED
        CHECK_RESULT $? 0 0 "Issue info SKIPPED check failed after fix on virtual machine"
    fi

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    # Restore issue and issue.net files
    if [[ -f "${ISSUE_FILE}-bak" ]]; then
        \cp "${ISSUE_FILE}-bak" "$ISSUE_FILE"
    fi
    
    if [[ -f "${ISSUE_NET_FILE}-bak" ]]; then
        \cp "${ISSUE_NET_FILE}-bak" "$ISSUE_NET_FILE"
    fi

    # Remove installed packages
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp ${ISSUE_FILE}-bak ${ISSUE_NET_FILE}-bak

    LOG_INFO "End to restore the test environment."
}

main "$@"
