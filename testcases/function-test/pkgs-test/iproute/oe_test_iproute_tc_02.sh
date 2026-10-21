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
# @Date      :   2023/06.12
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-iproute_tc
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "iproute"
    Net=$(nmcli connection show |awk 'NR==2' |awk '{print $NF}')
}

function run_test() {
    tc qdisc add dev "$Net" root netem loss 1%
    CHECK_RESULT $? 0 0 "add netem loss 1% fail"
    tc qdisc del dev "$Net" root netem loss 1%
    CHECK_RESULT $? 0 0 "del netem loss 1% fail"
    tc qdisc add dev "$Net" root netem loss 1% 30%
    CHECK_RESULT $? 0 0 "add netem loss 1%-3% fail"
    tc qdisc del dev "$Net" root netem loss 1% 30%
    CHECK_RESULT $? 0 0 "del netem loss 1%-3% fail"
    tc qdisc add dev "$Net" root netem duplicate 1%
    CHECK_RESULT $? 0 0 "add netem duplicate 1% fail"
    tc qdisc del dev "$Net" root netem duplicate 1%
    CHECK_RESULT $? 0 0 "del netem duplicate 1% fail"
    tc qdisc add dev "$Net" root netem corrupt 0.2%
    CHECK_RESULT $? 0 0 "add netem corrupt 0.2% fail"
    tc qdisc del dev "$Net" root netem corrupt 0.2%
    CHECK_RESULT $? 0 0 "del netem corrupt 0.2% fail"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
