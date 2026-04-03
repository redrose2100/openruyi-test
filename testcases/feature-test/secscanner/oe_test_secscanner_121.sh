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
# @Date      :   2026-4-3
# @License   :   Mulan PSL v2
# @Desc      :   disable_unused_user test (set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PASSWD_FILE="/etc/passwd"

# Users to check
UNUSED_USERS=(
    "adm"
    "lp"
    "sync"
    "shutdown"
    "halt"
    "news"
    "uucp"
    "operator"
    "games"
    "nobody"
    "rpm"
    "smmsp"
)

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$PASSWD_FILE" && ! -f "${PASSWD_FILE}-bak" ]]; then
        \cp "$PASSWD_FILE" "${PASSWD_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^disable_unused_user.*/disable_unused_user=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set disable_unused_user=yes"
    # Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if users' shell is /bin/false
    for user in "${UNUSED_USERS[@]}"; do
        if id -u "$user" >/dev/null 2>&1; then
            current_shell=$(grep -w "^$user:" "$PASSWD_FILE" | cut -d: -f7)
            if [[ "$current_shell" == "/bin/false" ]]; then
                LOG_INFO "$user shell is correctly set to /bin/false"
            else
                LOG_WARN "$user shell is not set to /bin/false: $current_shell"
            fi
        else
            LOG_INFO "User $user does not exist, skipping"
        fi
    done
    # Execute secscanner check level3 again
    secscanner check level3 > tmp && \mv tmp check
    # Check OK message
    grep -i "unused user" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "OK message not found"
    # Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if [[ -f "${PASSWD_FILE}-bak" ]]; then
        \cp "${PASSWD_FILE}-bak" "$PASSWD_FILE"
    fi
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; thens
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${PASSWD_FILE}-bak" ]]; then
        \cp "${PASSWD_FILE}-bak" "$PASSWD_FILE"
        rm -f "${PASSWD_FILE}-bak"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
