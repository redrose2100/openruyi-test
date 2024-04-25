#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   tunctl only for x86
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    frame="aarch64"
    [[ "${NODE1_FRAME}" = "${frame}" ]] && {
        LOG_INFO "tunctl doesn't support aarch64."
        exit 0
    }
    if [[ "${NODE1_FRAME}" = "riscv64" ]]; then
        file="https://download.opensuse.org/repositories/openSUSE:/Factory:/RISCV/standard/riscv64/tunctl-1.5-28.1.riscv64.rpm"
        wget "$file"
        rpm -ivh ./tunctl-1.5-28.1.riscv64.rpm
    else
        path="http://li.nux.ro/download/nux/misc/el7/x86_64/"
        wget "$path"
        tunctl=$(grep -oE "tunctl-.*.rpm" index.html | head -n 1 | awk -F'"' '{print $1}')
        wget "$path/$tunctl"
        rpm -ivh "$tunctl"
    fi
    DNF_INSTALL "net-tools"
    head_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1)
    ((head_ip++))
    ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 2-4)
    new_ip="$head_ip.$ip"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    modprobe tun
    CHECK_RESULT $? 0 0 "modprobe tun failed."
    lsmod | grep -q tun
    CHECK_RESULT $? 0 0 "Check mod tun failed."
    tunctl -t tap0 -u root
    CHECK_RESULT $? 0 0 "Create tap failed."
    ifconfig tap0 "$new_ip" netmask 255.255.255.0 promisc
    ip link | grep tap0
    CHECK_RESULT $? 0 0 "Create tap failed."
    ip tuntap del dev tap0 mod tap
    CHECK_RESULT $? 0 0 "Remove tap failed."
    ip link | grep tap0
    CHECK_RESULT $? 1 0 "tap0 is removed failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rpm -e tunctl
    if [[ "${NODE1_FRAME}" = "riscv64" ]]; then
        rm -rf ./tunctl-1.5-28.1.riscv64.rpm
    else
        rm -rf "$tunctl" index.html
    fi
    modprobe -r tun
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
