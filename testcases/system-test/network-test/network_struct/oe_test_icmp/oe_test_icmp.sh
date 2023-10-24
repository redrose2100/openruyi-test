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
#@Date      	:   2021-08-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Check icmp
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    ori_value=$(cat /proc/sys/net/ipv4/icmp_echo_ignore_all)

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    echo 0 >/proc/sys/net/ipv4/icmp_echo_ignore_all
    CHECK_RESULT $? 0 0 "Change icmp_echo_ignore_all = 1 failed."
    SSH_CMD "ping -c 5 ${NODE1_IPV4}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 0 0 "Ping failed."
    echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_all
    CHECK_RESULT $? 0 0 "Change icmp_echo_ignore_all = 0 failed."
    SSH_CMD "ping -c 5 ${NODE1_IPV4}" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $? 1 0 "Ping unexpectly."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    echo $ori_value >/proc/sys/net/ipv4/icmp_echo_ignore_all

    LOG_INFO "End to restore the test environment."
}

main "$@"
