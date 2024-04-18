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
#@Desc      	:   Create tun by tunctl
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
    route_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1-3).0
    head_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1)
    ((head_ip++))
    ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 2-4)
    new_ip="$head_ip.$ip"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    tunctl -n
    CHECK_RESULT $? 0 0 "Create tun failed."
    ip a | grep -q tun0
    CHECK_RESULT $? 0 0 "Check tun0 failed."
    ifconfig tun0 "$new_ip" up
    CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
    route add -host "$route_ip" dev tun0
    CHECK_RESULT $? 0 0 "Add host for tun0 failed."
    tunctl -d tun0
    CHECK_RESULT $? 0 0 "Delete tun failed."
    ip a | grep -q tun0
    CHECK_RESULT $? 1 0 "Check tun0 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rpm -e tunctl
    DNF_REMOVE "$@"
    if [[ "${NODE1_FRAME}" = "riscv64" ]]; then
        rm -rf ./tunctl-1.5-28.1.riscv64.rpm
    else
        rm -rf "$tunctl" index.html
    fi
    LOG_INFO "End to restore the test environment."
}

main "$@"
