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
    LOG_INFO "Start to prepare the database config."
    frame="aarch64"
    [[ ${NODE1_FRAME} -eq ${frame} ]] && {
        LOG_INFO "tunctl doesn't support aarch64."
        exit 0
    }
    wget http://li.nux.ro/download/nux/misc/el7/x86_64/tunctl-1.5-12.el7.nux.x86_64.rpm
    dnf install tunctl-1.5-12.el7.nux.x86_64.rpm -y
    DNF_INSTALL "net-tools"
    new_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1-3).120
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    tunctl -n
    CHECK_RESULT $? 0 0 "Create tun failed."
    ip a | grep -q tun0
    CHECK_RESULT $? 0 0 "Check tun0 failed."
    ifconfig tun0 "$new_ip" up
    CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
    route add -host 172.168.128.0 dev tun0
    CHECK_RESULT $? 0 0 "Add host for tun0 failed."
    tunctl -d tun0
    CHECK_RESULT $? 0 0 "Delete tun failed."
    ip a | grep -q tun0
    CHECK_RESULT $? 1 0 "Check tun0 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    dnf remove tunctl -y
    DNF_REMOVE "net-tools"
    rm -f tunctl-1.5-12.el7.nux.x86_64.rpm
    LOG_INFO "End to restore the test environment."
}

main "$@"
