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
# @Desc      :   Verify efibootmgr advanced operations
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "efibootmgr"
    if [ ! -d "/sys/firmware/efi" ]; then
    	LOG_INFO "Current machine is not UEFI boot, skip efibootmgr all test cases."
    	exit 255
    fi
    mkdir -p /boot/efi/EFI/test
    cp /boot/efi/EFI/openEuler/shimaa64.efi /boot/efi/EFI/test/test.efi
    cp /boot/efi/EFI/openEuler/shimaa64.efi /boot/efi/EFI/test/drv.efi
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    declare disk; disk="$(findmnt /boot/efi -o SOURCE -n | xargs lsblk -no PKNAME)" || exit 1
    declare part; part="$(findmnt /boot/efi -o SOURCE -n | xargs lsblk -no PARTN)" || exit 1
    efibootmgr -c -l '/EFI/test/test.efi' -L TestEntry -d "/dev/${disk}" -p "${part}" | grep -E 'Boot[0-9]+.*TestEntry'
    CHECK_RESULT $? 0 0 "Failed to create boot entry (-c)"
    bootnum_str="$(efibootmgr | grep TestEntry | awk '{sub("Boot","");sub("\\*","");print $1}')"
    efibootmgr -n "$bootnum_str" | grep "BootNext:"
    CHECK_RESULT $? 0 0 "Failed to set bootnext (-n)"
    efibootmgr -N
    CHECK_RESULT $? 0 0 "Failed to clear bootnext (-N)"
    efibootmgr | grep "BootNext"
    CHECK_RESULT $? 0 1 "Failed to verify bootnext cleared (-N)"
    efibootmgr -r -c -l '/EFI/test/drv.efi' -L TestDriver -d "/dev/${disk}" -p "${part}" | grep -E 'Driver[0-9]+.*TestDriver'
    CHECK_RESULT $? 0 0 "Failed to create driver entry (-r, -c)"
    efibootmgr -r | grep "TestDriver"
    CHECK_RESULT $? 0 0 "Failed to query UEFI driver variables (-r)"
    efibootmgr -c -I 0 -l '/EFI/test/test.efi' -L TestIndex -d "/dev/${disk}" -p "${part}" | grep -E 'Boot[0-9]+.*TestIndex'
    CHECK_RESULT $? 0 0 "Failed to create entry at index (-I)"
    efibootmgr -g | grep "GPT"
    CHECK_RESULT $? 0 0 "Failed to force GPT mode (-g)"
    echo "test" > /tmp/efibootmgr_args.txt
    efibootmgr -c -@ /tmp/efibootmgr_args.txt -l '\\EFI\\test\\test.efi' -d "/dev/${disk}" -p "${part}" | grep -E 'Boot[0-9]+'
    CHECK_RESULT $? 0 0 "Failed to read arguments from file (-@)"
    rm -f /tmp/efibootmgr_args.txt
    efibootmgr -i eth0 2>/dev/null | grep -E "netboot|IP4"
    CHECK_RESULT $? 0 1 "Failed to create netboot entry (-i)"
    efibootmgr -c -e 1 -l '/EFI/test/test.efi' -L TestEDD -d "/dev/${disk}" -p "${part}" 2>&1 | grep -E "EDD|TestEDD"
    CHECK_RESULT $? 0 0 "Failed to create entry with EDD 1.0 (-e)"
    efibootmgr -c -e 3 -E 0x80 -l '/EFI/test/test.efi' -L TestEDD3 -d "/dev/${disk}" -p "${part}" 2>&1 | grep -E "EDD|TestEDD3"
    CHECK_RESULT $? 0 0 "Failed to create entry with EDD 3.0 (-e, -E)"
    declare drvnum; drvnum="$(efibootmgr -r | grep TestDriver | awk '{sub("Driver","");sub("\\*","");print $1}')" || exit 1
    efibootmgr -r -b "$drvnum" -f | grep -E "reconnect|TestDriver"
    CHECK_RESULT $? 0 0 "Failed to reconnect devices (-f)"
    efibootmgr -r -b "$drvnum" -F | grep -E "reconnect|TestDriver"
    CHECK_RESULT $? 0 0 "Failed to disable reconnect (-F)"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    efibootmgr 2>/dev/null | grep -E "TestEntry|TestIndex|TestArg|TestEDD|TestEDD3" | awk '{print $1}' | sed 's/Boot//;s/\*//' | xargs -rI {} efibootmgr -b {} -B
    efibootmgr -r 2>/dev/null | grep "TestDriver" | awk '{print $1}' | sed 's/Driver//;s/\*//' | xargs -rI {} efibootmgr -r -b {} -B
    rm -f /tmp/efibootmgr_args.txt
    rm -rf /boot/efi/EFI/test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
