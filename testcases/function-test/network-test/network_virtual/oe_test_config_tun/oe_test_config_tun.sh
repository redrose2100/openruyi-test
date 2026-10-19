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
#@Desc      	:   Create tap service to start
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "net-tools wget"
    frame="aarch64"
    [[ "${NODE1_FRAME}" = "${frame}" ]] && {
        LOG_INFO "tunctl doesn't support aarch64."
        exit 0
    }
    cp ./config_tap.sh /etc/init.d/config_tap && chmod 777 /etc/init.d/config_tap
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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    /etc/init.d/config_tap start
    CHECK_RESULT $? 0 0 "Start config_tap failed."
    /etc/init.d/config_tap status
    CHECK_RESULT $? 0 0 "Check config_tap start failed."
    /etc/init.d/config_tap restart
    CHECK_RESULT $? 0 0 "Restart config_tap failed."
    /etc/init.d/config_tap status
    CHECK_RESULT $? 0 0 "Check config_tap restart failed."
    /etc/init.d/config_tap stop
    CHECK_RESULT $? 0 0 "Stop config_tap failed."
    /etc/init.d/config_tap status
    CHECK_RESULT $? 0 0 "Check config_tap stop failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ip tuntap del dev tap0 mod tap
    rpm -e tunctl
    if [[ "${NODE1_FRAME}" = "riscv64" ]]; then
        rm -rf ./tunctl-1.5-28.1.riscv64.rpm
    else
        rm -rf "$tunctl" index.html /etc/init.d/config_tap
    fi
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
