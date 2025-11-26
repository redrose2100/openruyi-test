#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2020/10/12
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in ndisc6 package
# ############################################
# shellcheck disable=SC1091,SC2154,SC2153
source "../common/common_ndisc6.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    NODE1_IPV6_2=$(ip addr show "${NODE1_NIC[0]}" | grep -w inet6 | awk '{print $2}' | awk -F '/' '{print $1}' | awk 'NR==2{print $1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    name2addr -4 newlocalhost | grep "${NODE1_IPV4}"
    CHECK_RESULT $?
    name2addr -6 newlocalhost | grep -E "${NODE1_IPV6}|$NODE1_IPV6_2"
    CHECK_RESULT $?
    name2addr -c newlocalhost | grep -E "${NODE1_NIC[0]}|${NODE1_IPV4}"
    CHECK_RESULT $?
    name2addr -m localhost newlocalhost | grep -E "${NODE1_IPV4}|${NODE1_IPV6}"
    CHECK_RESULT $?
    name2addr -n -r "${NODE1_IPV4}" | grep -E "newlocalhost|$hostname_init"
    CHECK_RESULT $?
    name2addr -n -r "${NODE1_IPV6}" | grep "newlocalhost"
    CHECK_RESULT $?
    ndisc6_version=$(rpm -qa ndisc6 | awk -F '-' '{print $2}')
    name2addr -V | grep "${ndisc6_version}"
    CHECK_RESULT $?
    name2addr -h | grep "name2addr"
    CHECK_RESULT $?
    echo "hello world" >file
    dnssort -r file | grep "hello world"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
