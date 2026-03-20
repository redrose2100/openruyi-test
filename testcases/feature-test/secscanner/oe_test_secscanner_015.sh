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
# @Date      :   2026-2-28
# @License   :   Mulan PSL v2
# @Desc      :   set_umask check when umask not set (extended to multiple files)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

FILES=(
    "/etc/profile"
    "/etc/csh.login"
    "/etc/csh.cshrc"
#    "/etc/bashrc"
    "/root/.bashrc"
    "/root/.cshrc"
)

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup and clean each file if it exists
    for file in "${FILES[@]}"; do
        if [[ -f "$file" && ! -f "${file}_bak" ]]; then
            \cp "$file" "${file}_bak"
            # Remove any existing umask line (including commented ones)
            sed -i '/^[[:space:]]*[^#]*umask/d' "$file" 2>/dev/nul
                fi
    done

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    \cp "$CONFIG_FILE" "${CONFIG_FILE}_bak"
    sed -i 's/^set_umask.*/set_umask=yes/' "$CONFIG_FILE"
    secscanner check basic > tmp && \mv tmp check
    grep -i "umask" check | grep WARNING
    CHECK_RESULT $? 0 0 "Overall umask WARNING check failed"
    # ---- secscanner fix ----
    secscanner fix basic > tmp && \mv tmp fix
    for file in "${FILES[@]}"; do
        if [[ -f "$file" ]]; then
            grep "umask 027" "$file"
            CHECK_RESULT $? 0 0 "File $file missing 'umask 027' after fix"
        fi
    done

    # ---- secscanner restore ----
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore each original file from its backup
    for file in "${FILES[@]}"; do
        if [[ -f "${file}_bak" ]]; then
            \cp "${file}_bak" "$file"
        fi
    done

    # Restore secScanner configuration and remove package
    [[ -f "${CONFIG_FILE}_bak" ]] && \mv "${CONFIG_FILE}_bak" "$CONFIG_FILE"
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
