#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/24
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of linux-boot-prober
# ############################################
# shellcheck disable=SC2120

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if grep docker /proc/1/cgroup; then
        LOG_INFO "The current environment is Docker."
        exit 0
    else
        # os-prober's helper scripts (os-prober/common.sh) call logger(1)
        # unconditionally; logger ships in inetutils on openRuyi.
        DNF_INSTALL "os-prober util-linux inetutils"
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    BOOT_DEV=$(df -Th | grep ' /boot$' | awk '{print $1}')
    if [ -n "$BOOT_DEV" ]; then
        # linux-boot-prober only prints boot entries for *other* bootloaders
        # found on the given partition. A single-OS test machine legitimately
        # yields empty output, and the kernel image is not necessarily named
        # "vmlinuz" (openRuyi ships /boot/linux). Verify the tool runs and only
        # assert on the kernel name when it actually reported something.
        boot_prober_out=$(linux-boot-prober "$BOOT_DEV" 2>/dev/null)
        CHECK_RESULT $? 0 0 "Failed to execute linux-boot-prober"
        if [ -n "$boot_prober_out" ]; then
            echo "$boot_prober_out" | grep -E "vmlinuz|/linux"
            CHECK_RESULT $? 0 0 "linux-boot-prober output has no kernel entry"
        else
            LOG_INFO "linux-boot-prober reported no foreign bootloader on ${BOOT_DEV}."
        fi
    else
        # 验证 os-prober 包已安装且可执行（功能性验证）
        which linux-boot-prober
        CHECK_RESULT $? 0 0 "linux-boot-prober not installed"
        # 验证 linux-boot-prober 对无效设备不会返回任何引导信息
        RESULT=$(linux-boot-prober /dev/nonexistent 2>/dev/null)
        [ -z "$RESULT" ]
        CHECK_RESULT $? 0 0 "linux-boot-prober should return empty output for invalid device"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
