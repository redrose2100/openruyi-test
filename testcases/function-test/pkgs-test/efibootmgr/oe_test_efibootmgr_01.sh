#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/16
# @License   :   Mulan PSL v2
# @Desc      :   Verify efibootmgr package integrity and basic queries
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "efibootmgr"
    if [ ! -d "/sys/firmware/efi" ]; then
    	LOG_INFO "Current machine is not UEFI boot, skip efibootmgr all test cases."
    	exit 255
    fi
    mkdir -p /boot/efi/EFI/test
    cp -f /boot/efi/EFI/openEuler/shimaa64.efi /boot/efi/EFI/test/test.efi
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    efibootmgr --version | grep -E "[0-9]+"
    CHECK_RESULT $? 0 0 "Failed to get efibootmgr version (-V)"
    efibootmgr --help | grep "efibootmgr"
    CHECK_RESULT $? 0 0 "Failed to run efibootmgr --help (-h)"
    efibootmgr -v | grep -E "DevicePath|HD|NVMe"
    CHECK_RESULT $? 0 0 "Failed to get verbose boot information (-v)"
    efibootmgr -t 10 | grep "Timeout: 10"
    CHECK_RESULT $? 0 0 "Failed to set boot timeout (-t)"
    efibootmgr -T
    CHECK_RESULT $? 0 0 "Failed to clear boot timeout (-T)"
    efibootmgr | grep "Timeout"
    CHECK_RESULT $? 0 1 "Failed to verify timeout cleared (-T)"
    efibootmgr -y | grep "SysPrepOrder"
    CHECK_RESULT $? 0 0 "Failed to operate on SysPrep variables (-y)"
    efibootmgr --full-dev-path | grep "HD("
    CHECK_RESULT $? 0 0 "Failed to use full device path (--full-dev-path)"
    declare disk; disk="$(findmnt /boot/efi -o SOURCE -n | xargs lsblk -no PKNAME)" || exit 1
    declare part; part="$(findmnt /boot/efi -o SOURCE -n | xargs lsblk -no PARTN)" || exit 1
    efibootmgr -c -l '/EFI/test/test.efi' -L TestEntry -d "/dev/${disk}" -p "${part}" | grep -E 'Boot[0-9]+.*TestEntry'
    CHECK_RESULT $? 0 0 "Failed to create boot entry (-c)"
    bootnum_str="$(efibootmgr | grep TestEntry | awk '{sub("Boot","");sub("\\*","");print $1}' | paste -sd,)"
    efibootmgr -o "$bootnum_str" | grep "BootOrder:"
    CHECK_RESULT $? 0 0 "Failed to set boot order (-o)"
    efibootmgr -O | grep "No BootOrder is set"
    CHECK_RESULT $? 0 0 "Failed to delete boot order (-O)"
    efibootmgr | grep "No BootOrder is set"
    CHECK_RESULT $? 0 0 "Failed to verify boot order deleted (-O)"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    efibootmgr 2>/dev/null | grep -E "TestEntry|TestIndex|TestArg|netboot|TestEDD" | awk '{print $1}' | sed 's/Boot//;s/\*//' | xargs -rI {} efibootmgr -b {} -B
    rm -rf /boot/efi/EFI/test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

