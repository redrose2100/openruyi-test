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
# @Date      :   2026-4-2
# @License   :   Mulan PSL v2
# @Desc      :   set_tmout test with existing TMOUT configuration (set to yes)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PROFILE_FILE="/etc/profile"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$PROFILE_FILE" && ! -f "${PROFILE_FILE}-bak" ]]; then
        \cp "$PROFILE_FILE" "${PROFILE_FILE}-bak"
        LOG_INFO "Backed up /etc/profile"
    fi
    # Remove existing TMOUT configuration
    sed -i '/^TMOUT/d' "$PROFILE_FILE"
    sed -i '/^export TMOUT/d' "$PROFILE_FILE"
    # Add existing TMOUT configuration with different value
    echo "TMOUT=300" >> "$PROFILE_FILE"
    echo "export TMOUT" >> "$PROFILE_FILE"
    LOG_INFO "Added existing TMOUT=300"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Set set_tmout=yes in secscanner.cfg
    sed -i 's/^set_tmout.*/set_tmout=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
    # Execute secscanner fix level3 and check profile content
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if TMOUT is overwritten to 180
    grep -E "^TMOUT=180" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 2: TMOUT not overwritten to 180"
    grep -E "^export TMOUT" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 2: export TMOUT not found"
    # Execute secscanner check level3 and check output
    secscanner check level3 > tmp && \mv tmp check
    grep -i "Has right TMOUT set" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 3: OK message not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/profile" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
    # Check if profile is restored
    grep -E "^TMOUT=300" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 6: profile not restored"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${PROFILE_FILE}-bak" ]]; then
        \cp "${PROFILE_FILE}-bak" "$PROFILE_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

