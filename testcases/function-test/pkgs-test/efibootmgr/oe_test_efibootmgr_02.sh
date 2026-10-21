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
# @Desc      :   Verify efibootmgr boot entry management
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
    declare disk; disk="$(findmnt /boot/efi -o SOURCE -n | xargs lsblk -no PKNAME)" || exit 1
    declare part; part="$(findmnt /boot/efi -o SOURCE -n | xargs lsblk -no PARTN)" || exit 1
    efibootmgr -c -l '\\EFI\\test\\test.efi' -L TestEntry -d "/dev/${disk}" -p "${part}" | grep -E 'Boot[0-9]+.*TestEntry'
    CHECK_RESULT $? 0 0 "Failed to create boot entry (-c)"
    bootnum_str="$(efibootmgr | grep TestEntry | awk '{sub("Boot","");sub("\\*","");print $1}' | paste -sd,)"
    efibootmgr -b "$bootnum_str" -a | grep -E "Boot${bootnum_str}.*\*"
    CHECK_RESULT $? 0 0 "Failed to activate boot entry (-a, -b)"
    efibootmgr -b "$bootnum_str" -A | grep -E "Boot${bootnum_str}" | grep -v "\*"
    CHECK_RESULT $? 0 0 "Failed to deactivate boot entry (-A, -b)"
    efibootmgr -b "$bootnum_str" -B
    CHECK_RESULT $? 0 0 "Failed to delete boot entry (-B, -b)"
    efibootmgr | grep "RenamedEntry"
    CHECK_RESULT $? 0 1 "Failed to verify boot entry deleted (-B)"
    efibootmgr -c -C -l '/EFI/test/test.efi' -L CreateOnly -d "/dev/${disk}" -p "${part}" | grep -E 'Boot[0-9]+.*CreateOnly'
    CHECK_RESULT $? 0 0 "Failed to create-only boot entry (-C)"
    tempnum_str="$(efibootmgr | grep CreateOnly | awk '{sub("Boot","");sub("\\*","");print $1}')"
    efibootmgr | grep "CreateOnly" | grep -v "BootOrder" > /dev/null
    CHECK_RESULT $? 0 0 "Failed to verify create-only entry not in bootorder (-C)"
    efibootmgr -b "$tempnum_str" -B
    CHECK_RESULT $? 0 0 "Failed to delete create-only boot entry"
    efibootmgr -D | grep "BootOrder"
    CHECK_RESULT $? 0 0 "Failed to remove duplicate boot entries (-D)"
    efibootmgr --file-dev-path | grep "File("
    CHECK_RESULT $? 0 0 "Failed to use file device path (--file-dev-path)"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    efibootmgr 2>/dev/null | grep -E "TestEntry|TestIndex|TestArg|netboot|CreateOnly|TestEDD" | awk '{print $1}' | sed 's/Boot//;s/\*//' | xargs -rI {} efibootmgr -b {} -B
    rm -rf /boot/efi/EFI/test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
