#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-16
#@License   	:   Mulan PSL v2
#@Desc      	:   tunctl only for x86
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    
    [[ ${NODE1_FRAME} -eq "aarch64" ]] && {
        LOG_INFO "tunctl doesn't support aarch64."
        exit 0
    }
    wget http://li.nux.ro/download/nux/misc/el7/x86_64/tunctl-1.5-12.el7.nux.x86_64.rpm
    DNF_INSTALL "net-tools tunctl-1.5-12.el7.nux.x86_64.rpm"
    new_ip=$(echo ${NODE1_IPV4} | cut -d '.' -f 1-3).120

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    modprobe tun
    CHECK_RESULT $? 0 0 "modprobe tun failed."
    lsmod | grep -q tun
    CHECK_RESULT $? 0 0 "Check mod tun failed."
    tunctl -t tap0 -u root
    CHECK_RESULT $? 0 0 "Create tap failed."
    ifconfig tap0 $new_ip netmask 255.255.255.0 promisc
    ip tuntap del dev tap0 mod tap
    CHECK_RESULT $? 0 0 "Remove tap failed."
    ip link | grep -q tap0
    CHECK_RESULT $? 0 0 "tap0 is removed failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f tunctl-1.5-12.el7.nux.x86_64.rpm
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
