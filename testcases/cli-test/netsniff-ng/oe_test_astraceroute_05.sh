#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshou
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test astraceroute
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    # test -L
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -L > tmp.txt &
    local index=1
    while true;do
        ((index++))
        grep "1: " tmp.txt
        result=$?
        if [[ ${result} == 0 ]]; then
            break
        fi
        SLEEP_WAIT 5
        if [[ ${index} -gt 30 ]]; then
            LOG_ERROR "astraceroute test -L timeout"
            break
        fi
    done
    grep -E "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -L failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --latitude
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --latitude > tmp.txt &
    local index=1
    while true;do
        ((index++))
        grep "1: " tmp.txt
        result=$?
        if [[ ${result} == 0 ]]; then
            break
        fi
        SLEEP_WAIT 5
        if [[ ${index} -gt 30 ]]; then
            LOG_ERROR "astraceroute test --latitude timeout"
            break
        fi
    done
    grep -E "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --latitude failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -t
    astraceroute --dev ${NODE1_NIC} -H netsniff-ng.org -t 4 > tmp.txt &
    SLEEP_WAIT 5
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -t failed"
    kill -9 $(pgrep -f "astraceroute --dev")
    rm -f tmp.txt
    # test --tos
    astraceroute --dev ${NODE1_NIC} -H netsniff-ng.org --tos 4 > tmp.txt &
    SLEEP_WAIT 5
    grep "AS path IPv4 TCP trace from" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --tos failed"
    kill -9 $(pgrep -f "astraceroute --dev")
    rm -f tmp.txt
    # test -G
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -G > tmp.txt &
    local index=1
    while true;do
        ((index++))
        grep "1: " tmp.txt
        result=$?
        if [[ ${result} == 0 ]]; then
            break
        fi
        SLEEP_WAIT 5
        if [[ ${index} -gt 30 ]]; then
            LOG_ERROR "astraceroute test -G timeout"
            break
        fi
    done
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -G failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --nofrag
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --nofrag > tmp.txt &
    local index=1
    while true;do
        ((index++))
        grep "1: " tmp.txt
        result=$?
        if [[ ${result} == 0 ]]; then
            break
        fi
        SLEEP_WAIT 5
        if [[ ${index} -gt 30 ]]; then
            LOG_ERROR "astraceroute test --nofrag timeout"
            break
        fi
    done
    grep "Using flags SYN:0,ACK:0,ECN:0,FIN:0,PSH:0,RST:0,URG:0" tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --nofrag failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test -Z
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org -Z > tmp.txt &
    local index=1
    while true;do
        ((index++))
        grep "6: " tmp.txt
        result=$?
        if [[ ${result} == 0 ]]; then
            break
        fi
        SLEEP_WAIT 5
        if [[ ${index} -gt 30 ]]; then
            LOG_ERROR "astraceroute test -Z timeout"
            break
        fi
    done
    grep "Chr .." tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute -Z failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    # test --show-packet
    astraceroute -i ${NODE1_NIC} -H netsniff-ng.org --show-packet > tmp.txt &
    local index=1
    while true;do
        ((index++))
        grep "6: " tmp.txt
        result=$?
        if [[ ${result} == 0 ]]; then
            break
        fi
        SLEEP_WAIT 5
        if [[ ${index} -gt 30 ]]; then
            LOG_ERROR "astraceroute test --show-packet timeout"
            break
        fi
    done
    grep "Chr .." tmp.txt
    CHECK_RESULT $? 0 0 "Check astraceroute --show-packet failed"
    kill -9 $(pgrep -f "astraceroute -i")
    rm -f tmp.txt
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
