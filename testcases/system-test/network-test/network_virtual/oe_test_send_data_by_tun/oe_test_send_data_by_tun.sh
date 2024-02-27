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
#@Desc      	:   Send data to test tun
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tcpdump gcc"
    make
    modprobe tun
    head_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1)
    ((head_ip++))
    ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 2-4)
    new_ip="$head_ip.$ip"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup ./test_tun &
    SLEEP_WAIT 2
    ip link | grep -q tun0
    CHECK_RESULT $? 0 0 "Create new tun failed."
    ip addr add "${new_ip}"/24 dev tun0
    CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
    ip link set dev tun0 up
    CHECK_RESULT $? 0 0 "ip link set dev tun0 up failed."
    nohup tcpdump -i tun0 -c 5 &
    SLEEP_WAIT 2
    ping -c 4 "${new_ip}" -I tun0
    CHECK_RESULT $? 0 0 "ping tun0 failed."
    pgrep -f "test_tun|tcpdump" | xargs kill -9
    ip link | grep -q tun0
    CHECK_RESULT $? 1 0 "The tun0 is deleted failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    make clean
    modprobe -r tun
    DNF_REMOVE "$@"
    rm -rf test_tun nohup.out test_tun.log
    LOG_INFO "End to restore the test environment."
}

main "$@"
