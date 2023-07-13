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
#@Date      	:   2021-08-16
#@License   	:   Mulan PSL v2
#@Desc      	:   Create tap by ip tuntap
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL net-tools
    new_ip=$(echo ${NODE1_IPV4} | cut -d '.' -f 1-3).120

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    ip tuntap add dev tun0 mod tun
    CHECK_RESULT $? 0 0 "Add ip for tun0 failed."
    ifconfig tun0 ${new_ip} up
    CHECK_RESULT $? 0 0 "Up tun0 failed."
    route add -host 172.168.128.0 dev tun0
    CHECK_RESULT $? 0 0 "Add rout for tun0 failed."
    ip tuntap del dev tun0 mod tun
    CHECK_RESULT $? 0 0 "Delete tun0 failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
