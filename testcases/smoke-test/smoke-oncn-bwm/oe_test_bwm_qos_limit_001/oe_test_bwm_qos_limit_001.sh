#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   wangtingting 
# @Contact   :   wangting199611@126.com
# @Date      :   2023/10/12
# @Desc      :   bwmcli test
# ##################################
# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    DNF_INSTALL oncn-bwm
}

function run_test() {
    LOG_INFO "Start to run test."
    bwmcli -e "${NODE1_NIC}" -e lo
    CHECK_RESULT $? 0 0 "CHECK bwmcli -e FAILED"
    bwmcli -d "${NODE1_NIC}" -d lo
    CHECK_RESULT $? 0 0 "CHECK bwmcli -d FAILED"

    mkdir /sys/fs/cgroup/net_cls/offline
    bwmcli -s /sys/fs/cgroup/net_cls/offline -1
    CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
    bwmcli -p /sys/fs/cgroup/net_cls/offline
    CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"

    bwmcli -s /sys/fs/cgroup/net_cls/offline 0
    CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
    bwmcli -p /sys/fs/cgroup/net_cls/offline
    CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"

    bwmcli -s bandwidth 20mb,50mb
    CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
    bwmcli -p bandwidth
    CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"

    bwmcli -s waterline 30mb
    CHECK_RESULT $? 0 0 "CHECK bwmcli -s FAILED"
    bwmcli -p waterline
    CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"

    bwmcli -p stats
    CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
    bwmcli -p devs
    CHECK_RESULT $? 0 0 "CHECK bwmcli -p FAILED"
    LOG_INFO "End of the test."
}

function post_test() {
    DNF_REMOVE
    rmdir /sys/fs/cgroup/net_cls/offline
}

main "$@"
