#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/06/08
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of dracut
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        mv -f /boot/initrd.img-$(uname -r) /boot/initrd.img-$(uname -r)_bak
    else
        kernel_ver=$(rpm -qa kernel | sort | tail -n 1 | awk -F '-' '{print $2"-"$3}')
        mv -f /boot/initramfs-"${kernel_ver}".img /boot/initramfs-"${kernel_ver}".img.bak
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if ! df -h / |grep overlay; then
        if [ "${NODE1_OS_VERSION}" == "debian" ];then
            mkinitramfs -o /boot/initrd.img-$(uname -r)
            CHECK_RESULT $? 0 0 "Failed to execute mkinitramfs"
            test -f /boot/initrd.img-$(uname -r)
            CHECK_RESULT $? 0 0 "Failed to check mkinitramfs"
        else
            dracut /boot/initramfs-"${kernel_ver}".img
            CHECK_RESULT $? 0 0 "Failed to execute dracut"
            test -f /boot/initramfs-"${kernel_ver}".img
            CHECK_RESULT $? 0 0 "Failed to check dracut"
        fi
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ "${NODE1_OS_VERSION}" == "debian" ];then
        mv -f /boot/initrd.img-$(uname -r)_bak /boot/initrd.img-$(uname -r)
    else
        mv -f /boot/initramfs-"${kernel_ver}".img.bak /boot/initramfs-"${kernel_ver}".img
    fi
    LOG_INFO "End to restore the test environment."
}

main "$@"
