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
# @Date      :   2026-4-1
# @License   :   Mulan PSL v2
# @Desc      :   set_nologin_list=yes test (password-auth)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PASSWORD_AUTH_FILE="/etc/pam.d/password-auth"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$PASSWORD_AUTH_FILE" && ! -f "${PASSWORD_AUTH_FILE}-bak" ]]; then
        \cp "$PASSWORD_AUTH_FILE" "${PASSWORD_AUTH_FILE}-bak"
        LOG_INFO "Backed up /etc/pam.d/password-auth"
    fi
    sed -i '/pam_listfile.so.*login.user.deny/d' "$PASSWORD_AUTH_FILE"
    LOG_INFO "Removed existing nologin list configurations from password-auth"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_nologin_list=yes in secscanner.cfg
    sed -i 's/^set_nologin_list.*/set_nologin_list=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=yes"
    # Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    grep -i "list of users prohibited from login" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
    # Execute secscanner fix basic and check password-auth file
    secscanner fix basic > tmp && \mv tmp fix
    # Check password-auth file
    grep -E "auth\s+required\s+pam_listfile\.so\s+item=user\s+onerr=succeed\s+sense=deny\s+file=/etc/login\.user\.deny" "$PASSWORD_AUTH_FILE"
    CHECK_RESULT $? 0 0 "Step 3: pam_listfile not added to password-auth"
    # Debug: Show current password-auth configuration
    LOG_INFO "Current password-auth configuration:"
    grep -i "pam_listfile" "$PASSWORD_AUTH_FILE"
    # Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    grep -i "list of users prohibited from login" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 4: OK message not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/pam.d/password-auth" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: password-auth restore message not found"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${PASSWORD_AUTH_FILE}-bak" ]]; then
        \cp "${PASSWORD_AUTH_FILE}-bak" "$PASSWORD_AUTH_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

