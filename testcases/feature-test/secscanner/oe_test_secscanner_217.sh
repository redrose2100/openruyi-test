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
# @Date      :   2026-4-15
# @License   :   Mulan PSL v2
# @Desc      :   set_prohibition_usb test (set to no, USB storage not prohibited, euler)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

CONFIG_FILE="/etc/secScanner/secscanner.cfg"
USB_CONF="/etc/modprobe.d/prohibit_usb.conf"
USB_CONF_EXISTED=0

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Check current USB storage status
    LOG_INFO "Current USB storage status:"
    modprobe -n -v usb-storage
    # Check if USB_CONF exists
    if [[ -f "$USB_CONF" ]]; then
        LOG_INFO "USB prohibition config exists, backing up"
        \cp "$USB_CONF" "${USB_CONF}-bak"
        USB_CONF_EXISTED=1
        # Remove USB prohibition for test
        rm -f "$USB_CONF"
    fi
    # Verify USB storage is not prohibited
    LOG_INFO "USB storage status after removing prohibition:"
    modprobe -n -v usb-storage
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Backing up secscanner.cfg"
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_prohibition_usb=no in secscanner.cfg
    sed -i 's/^set_prohibition_usb.*/set_prohibition_usb=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_prohibition_usb=no"
    # Check if USB storage is not prohibited before fix
    LOG_INFO "Checking USB storage status before fix:"
    USB_STATUS=$(modprobe -n -v usb-storage)
    echo "USB_STATUS: $USB_STATUS"
    # Verify USB storage is not prohibited (should contain insmod)
    if [[ "$USB_STATUS" != *"insmod"* ]]; then
        LOG_ERROR "USB storage should not be prohibited before fix"
        return 1
    fi
    # Execute secscanner check euler
    LOG_INFO "Executing secscanner check euler"
    secscanner check euler > tmp && \mv tmp check
    # Execute secscanner fix euler
    LOG_INFO "Executing secscanner fix euler"
    secscanner fix euler > tmp && \mv tmp fix
    # Check if USB storage is still not prohibited after fix
    LOG_INFO "Checking USB storage status after fix:"
    USB_STATUS=$(modprobe -n -v usb-storage)
    # 当set_prohibition_usb=no时，USB存储不应该被禁止，应该输出包含insmod
    echo "$USB_STATUS" | grep "insmod"
    CHECK_RESULT $? 0 0 "当set_prohibition_usb=no时，USB存储不应该被禁止，应该输出包含insmod"
    # 当set_prohibition_usb=no时，不应该存在USB禁止配置文件
    test ! -f "$USB_CONF"
    CHECK_RESULT $? 0 0 "当set_prohibition_usb=no时，不应该存在USB禁止配置文件"
    # Execute secscanner restore all
    LOG_INFO "Executing secscanner restore all"
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Restoring secscanner.cfg from backup"
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Remove USB prohibition created by test
    if [[ -f "$USB_CONF" ]]; then
        LOG_INFO "Removing USB prohibition config created by test"
        rm -f "$USB_CONF"
    fi
    # Restore original USB_CONF if it existed
    if [[ $USB_CONF_EXISTED -eq 1 ]]; then
        LOG_INFO "Restoring original USB prohibition config"
        \cp "${USB_CONF}-bak" "$USB_CONF"
    fi
    # Verify environment is restored
    LOG_INFO "USB storage status after restoration:"
    modprobe -n -v usb-storage
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
