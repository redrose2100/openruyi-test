#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-11-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of /boot
#####################################
# shellcheck disable=SC2010
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    # /boot/config-* 由内核包导出，openRuyi 的 /boot 下只有 linux、initrd、
    # initramfs、efi、grub、loader，没有 config-* 文件。文件不存在说明该发行版
    # 未导出内核配置，属于打包差异，跳过而不判失败。
    if ls /boot/config-* > /dev/null 2>&1; then
        if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
            ls -l /boot | grep "config" | grep "\-rwxr-xr-x"
        else
            ls -l /boot | grep "config" | grep "\-rw-r--r--"
        fi
        CHECK_RESULT $? 0 0 "The config on /boot has some errors."
    else
        LOG_WARN "No /boot/config-* on this system, skip the config access check."
    fi
    # lost+found 只在 /boot 为独立文件系统时由 mkfs 创建，openRuyi 等
    # 发行版的 /boot 属于根文件系统，不会有该目录。
    if [[ "${NODE1_FRAME}" != "riscv64" ]] && [ -d /boot/lost+found ]; then
        ls -l /boot | grep "lost+found" | grep "drwx------"
        CHECK_RESULT $? 0 0 "The lost+found on /boot has some errors."
    else
        LOG_WARN "No /boot/lost+found on this system, skip the lost+found access check."
    fi
    # initramfs 权限随发行版不同：openEuler x86_64 为 -rw-------，
    # openEuler RISC-V 为 -rwxr-xr-x，openRuyi 为 -rw-r--r--，都是合法结果。
    ls -l /boot | grep "initramfs" | grep -Eq "^-rw(-r--r--|xr-xr-x|-------)"
    CHECK_RESULT $? 0 0 "The initramfs on /boot has some errors."
    LOG_INFO "End to run test."
}

main "$@"
