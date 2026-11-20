#!/usr/bin/bash

#Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-29
# @License   :   Mulan PSL v2
# @Desc      :   Network commonly used command test-ifconfig
# #############################################

source ../common/net_lib.sh
function config_params() {
    LOG_INFO "Start to config params of the case."
    get_free_eth 1
    eth_name=${LOCAL_ETH[0]}
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL inetutils
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ifconfig "${eth_name}" down
    CHECK_RESULT $?
    ifconfig "${eth_name}" | grep "${eth_name}" | grep "UP"
    CHECK_RESULT $? 1
    ifconfig "${eth_name}" up
    CHECK_RESULT $?
    # 网卡 up 是异步生效的，内核置位 IFF_UP 与链路 carrier 恢复有延迟，
    # 紧接着取标志位会偶发读到未置位的旧值。这里做有界等待再断言。
    for _i in $(seq 1 20); do
        ifconfig "${eth_name}" 2>/dev/null | grep -q "UP"
        [ $? -eq 0 ] && break
        sleep 0.5
    done
    ifconfig "${eth_name}" | grep "${eth_name}" | grep "UP"
    CHECK_RESULT $? 0 0 "ifconfig ${eth_name} should report the UP flag after 'ifconfig ${eth_name} up'"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
