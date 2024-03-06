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
#@Desc      	:   Check iperf3
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL iperf3
    DNF_INSTALL iperf3 2
    P_SSH_CMD --node 2 --cmd "systemctl stop firewalld"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "echo q | nohup iperf3 -s &>/dev/null &"
    CHECK_RESULT $? 0 0 "Start iperf3 tcp server failed."
    iperf3 -c "${NODE2_IPV4}" -P 10 -t 60
    CHECK_RESULT $? 0 0 "Check tcp failed."
    P_SSH_CMD --node 2 --cmd "echo q | nohup iperf3 -s -u &>/dev/null &"
    CHECK_RESULT $? 0 0 "Start iperf3 udp server failed."
    iperf3 -u -c "${NODE2_IPV4}" -P 10 -t 60
    CHECK_RESULT $? 0 0 "Check udp failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "kill -9 $(pgrep -f iperf3)
    systemctl start firewalld"
    DNF_REMOVE "$@"
    DNF_REMOVE 2 "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
