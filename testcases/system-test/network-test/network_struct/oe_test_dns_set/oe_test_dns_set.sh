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
#@Desc      	:   Set DNS
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "bind net-tools"
    cp /etc/named.conf /etc/named.conf.bak
    cp /etc/resolv.conf /etc/resolv.conf.bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    default_dns=$(grep -E '^nameserver' /etc/resolv.conf -m 1 | awk '{print $2}')
    if [ -z "$default_dns" ]; then
        CHECK_RESULT 1 0 0 "Check default dns failed."
    fi
    netstat -antlpe | grep "named" | grep 53
    CHECK_RESULT $? 1 0 "The port 53 already opened."
    sed -i "s/localhost/any/g" /etc/named.conf
    CHECK_RESULT $? 0 0 "Change /etc/named.conf to open port 53 failed."
    systemctl restart named
    CHECK_RESULT $? 0 0 "Restart named server opened."
    netstat -antlpe | grep "named" | grep 53
    CHECK_RESULT $? 0 0 "The port 53 doesn't opened."
    echo "   search test.com
   nameserver ${NODE1_IPV4}" >/etc/resolv.conf
    CHECK_RESULT $? 0 0 "Change /etc/resolv.conf failed."
    ping www.baidu.com -c 4
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/named.conf.bak /etc/named.conf
    mv -f /etc/resolv.conf.bak /etc/resolv.conf
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
