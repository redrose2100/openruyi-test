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
# @Desc      :   bandwidth qos test 
# ##################################
# shellcheck disable=SC1091,SC2002,SC2035
source ../common/comlib.sh

function pre_test() {
    DNF_INSTALL "oncn-bwm iperf3"
    DNF_INSTALL iperf3 2
    P_SSH_CMD --cmd "systemctl stop firewalld"
}

function run_test() {
    LOG_INFO "Start to run test."

    mkdir /sys/fs/cgroup/net_cls/{offline,online}
    bwmcli -e "${NODE1_NIC}"
    bwmcli -s /sys/fs/cgroup/net_cls/offline -1
    bwmcli -s /sys/fs/cgroup/net_cls/online 0
    bwmcli -s bandwidth 30mb,50mb
    bwmcli -s waterline 30mb

    P_SSH_CMD --cmd "iperf3 -s -p 50051 -D"
    P_SSH_CMD --cmd "iperf3 -s -p 50052 -D"

    LOG_INFO "Start to test case1"
    deploy_client "$NODE2_IPV4" 15 480 50051 offline offline.log
    wait_client_stop 50051 20
    off_bdw=$(cat offline.log | grep sender | awk '{print $(NF-3)}')
    diff=$(get_diff 50 "$off_bdw")
    if [ "$diff" -gt 10 ];then
        CHECK_RESULT $? 0 1 "qos test failed."
    fi

    LOG_INFO "Start to test case2"
    deploy_client "$NODE2_IPV4" 15 480 50051 offline offline1.log
    deploy_client "$NODE2_IPV4" 15 160 50052 online online1.log
    wait_client_stop 50052 20
    off_bdw=$(cat offline1.log | grep sender | awk '{print $(NF-3)}')
    diff=$(get_diff 50 "$off_bdw")
    if [ "$diff" -gt 10 ];then
        CHECK_RESULT $? 0 1 "qos test failed."
    fi
    target_bdw=$(bwmcli -p stats | grep offline_target_bandwidth | awk -F ': ' '{print $2}')
    CHECK_RESULT "$target_bdw" 52428800 0 "query failed."

    LOG_INFO "Start to test case3"
    deploy_client "$NODE2_IPV4" 15 480 50051 offline offline2.log
    sleep 5
    deploy_client "$NODE2_IPV4" 15 320 50052 online online2.log
    sleep 5
    target_bdw=$(bwmcli -p stats | grep offline_target_bandwidth | awk -F ': ' '{print $2}')
    CHECK_RESULT "$target_bdw" 31457280 0 "query failed."
    wait_client_stop 50052 15

    off_bdw_before=$(get_avg offline2.log 8 8)
    diff_before=$(get_diff 50 "$off_bdw_before")
    if [ "$diff_before" -gt 10 ];then
        CHECK_RESULT $? 0 1 "qos test failed."
    fi
    off_bdw_after=$(get_avg offline2.log 30 8)
    diff_after=$(get_diff 30 "$off_bdw_after")
    if [ "$diff_after" -gt 10 ];then
        CHECK_RESULT $? 0 1 "qos test failed."
    fi

    LOG_INFO "Start to test case4"
    deploy_client "$NODE2_IPV4" 15 480 50052 online online.log
    wait_client_stop 50052 20
    on_bdw=$(cat online.log | grep sender | awk '{print $(NF-3)}')
    diff=$(get_diff 60 "$on_bdw")
    if [ "$diff" -gt 10 ];then
        CHECK_RESULT $? 0 1 "qos test failed."
    fi

    LOG_INFO "Start to test case5"
    deploy_client "$NODE2_IPV4" 15 240 50051 offline offline3.log
    deploy_client "$NODE2_IPV4" 15 320 50052 online online3.log
    wait_client_stop 50052 20
    off_bdw=$(cat offline3.log | grep sender | awk '{print $(NF-3)}')
    diff=$(get_diff 30 "$off_bdw")
    if [ "$diff" -gt 10 ];then
        CHECK_RESULT $? 0 1 "qos test failed."
    fi

    LOG_INFO "End of the test."
}

function post_test() {
    P_SSH_CMD --cmd "pkill -9 iperf3"
    P_SSH_CMD --cmd "systemctl start firewalld"
    rmdir /sys/fs/cgroup/net_cls/{offline,online}
    rm -rf *.log
    DNF_REMOVE
    DNF_REMOVE 2
}

main "$@"

