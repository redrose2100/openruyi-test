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
# @Desc      :   set_limit_resources test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LIMITS_CONF_FILE="/etc/security/limits.conf"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$LIMITS_CONF_FILE" && ! -f "${LIMITS_CONF_FILE}-bak" ]]; then
        \cp "$LIMITS_CONF_FILE" "${LIMITS_CONF_FILE}-bak"
        LOG_INFO "Backed up /etc/security/limits.conf"
    fi
    sed -i '/^\*\s*soft\s*stack\s*1024/d' "$LIMITS_CONF_FILE"
    sed -i '/^\*\s*hard\s*stack\s*1024/d' "$LIMITS_CONF_FILE"
    sed -i '/^\*\s*hard\s*rss\s*100000/d' "$LIMITS_CONF_FILE"
    sed -i '/^\*\s*hard\s*nproc\s*4000/d' "$LIMITS_CONF_FILE"
    sed -i '/^\*\s*hard\s*maxlogins\s*3/d' "$LIMITS_CONF_FILE"
    LOG_INFO "Removed existing resource limit configurations"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_limit_resources=yes in secscanner.cfg
    sed -i 's/^set_limit_resources.*/set_limit_resources=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_limit_resources=yes"
    # Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    grep -i "limit of system resources" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
    # Execute secscanner fix basic and check limits.conf content
    secscanner fix basic > tmp && \mv tmp fix
    # Check resource limit configurations
    grep -E "^\*\s*soft\s*stack\s*1024" "$LIMITS_CONF_FILE"
    CHECK_RESULT $? 0 0 "Step 3: soft stack limit not set"
    grep -E "^\*\s*hard\s*stack\s*1024" "$LIMITS_CONF_FILE"
    CHECK_RESULT $? 0 0 "Step 3: hard stack limit not set"
    grep -E "^\*\s*hard\s*rss\s*100000" "$LIMITS_CONF_FILE"
    CHECK_RESULT $? 0 0 "Step 3: hard rss limit not set"
    grep -E "^\*\s*hard\s*nproc\s*4000" "$LIMITS_CONF_FILE"
    CHECK_RESULT $? 0 0 "Step 3: hard nproc limit not set"
    grep -E "^\*\s*hard\s*maxlogins\s*3" "$LIMITS_CONF_FILE"
    CHECK_RESULT $? 0 0 "Step 3: hard maxlogins limit not set"
    # Debug: Show current resource limit configurations
    LOG_INFO "Current resource limit configurations:"
    grep -E "^(\*\s*soft\s*stack|\*\s*hard\s*stack|\*\s*hard\s*rss|\*\s*hard\s*nproc|\*\s*hard\s*maxlogins)" "$LIMITS_CONF_FILE"
    # Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    grep -i "limit of system resources" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 4: OK message not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/security/limits.conf" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${LIMITS_CONF_FILE}-bak" ]]; then
        \cp "${LIMITS_CONF_FILE}-bak" "$LIMITS_CONF_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

