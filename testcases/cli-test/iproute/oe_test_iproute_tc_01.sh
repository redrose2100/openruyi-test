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
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023/06.06
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-iproute_tc
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "iproute"
    Net=$(nmcli -f device connection show |awk 'NR==2' |awk '{print $1}')
}

function run_test() {
    tc qdisc ls |grep "$Net"
    CHECK_RESULT $? 0 0 "queue status display failure"
    tc qdisc show dev "$Net" |grep qdisc
    CHECK_RESULT $? 0 0 "The NIC status fails to be displayed"
    tc qdisc add dev "$Net" root netem delay 100ms
    CHECK_RESULT $? 0 0 "Failed to delay setting for 100 milliseconds"
    tc qdisc del dev "$Net" root netem delay 100ms
    CHECK_RESULT $? 0 0 "Failed to delete the 100ms delay setting"
    tc qdisc add dev "$Net" root netem delay 100ms 10ms
    CHECK_RESULT $? 0 0 "Failed to set the delay value with volatility"
    tc qdisc del dev "$Net" root netem delay 100ms 10ms
    CHECK_RESULT $? 0 0 "Failed to delete a delay value setting with volatility"
    tc qdisc add dev "$Net" root netem delay 100ms 10ms 30%
    CHECK_RESULT $? 0 0 "set 30% packets, the delay fails"
    tc qdisc del dev "$Net" root netem delay 100ms 10ms 30%
    CHECK_RESULT $? 0 0 "Deleting 30% packets fails. Procedure"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
