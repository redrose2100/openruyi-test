#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-23 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run net-tools testsuite
#####################################
# shellcheck disable=SC1091
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run net-tools test."
    arp
    CHECK_RESULT $? 0 0 "check arp failed!"
    arp -a
    CHECK_RESULT $? 0 0 "check arp -afailed!"
    arp -D -v
    CHECK_RESULT $? 0 0 "check arp -D -v failed!"

    ifconfig
    CHECK_RESULT $? 0 0 "check ifconfig failed!"
    ifconfig -a
    CHECK_RESULT $? 0 0 "check ifconfig -a failed!"
    if [[ $(ifconfig -a) =~ "tunl0" ]]; then
        ifconfig tunl0 down
        CHECK_RESULT $? 0 0 "check ifconfig tunl0 down failed!"
        ifconfig | grep "^tunl0"
        CHECK_RESULT $? 1 0 "check ifconfig failed!"
        ifconfig tunl0 up
        CHECK_RESULT $? 0 0 "check ifconfig tunl0 up failed!"
        ifconfig | grep "^tunl0"
        CHECK_RESULT $? 0 0 "check ifconfig failed!"
    fi

    iptunnel
    CHECK_RESULT $? 0 0 "check iptunnel failed!"

    netstat
    CHECK_RESULT $? 0 0 "check netstat failed!"
    netstat -a
    CHECK_RESULT $? 0 0 "check netstat -a failed!"
    netstat -apu
    CHECK_RESULT $? 0 0 "check netstat -apu failed!"
    netstat -apt | grep "tcp"
    CHECK_RESULT $? 0 0 "check netstat -apt failed!"
    netstat -l
    CHECK_RESULT $? 0 0 "check netstat -l failed!"
    netstat -at | grep tcp
    CHECK_RESULT $? 0 0 "check netstat -at failed!"
    netstat -au
    CHECK_RESULT $? 0 0 "check netstat -au failed!"
    netstat -ax | grep unix
    CHECK_RESULT $? 0 0 "check netstat -ax failed!"
    netstat -lt | grep tcp
    CHECK_RESULT $? 0 0 "check netstat -lt failed!"
    netstat -lu
    CHECK_RESULT $? 0 0 "check netstat -lu failed!"
    netstat -r
    CHECK_RESULT $? 0 0 "check netstat -r failed!"
    netstat -pt
    CHECK_RESULT $? 0 0 "check netstat -pt failed!"
    netstat -an
    CHECK_RESULT $? 0 0 "check netstat -an failed!"

    route
    CHECK_RESULT $? 0 0 "check route failed!"
    route add default gw "${NODE1_IPV4}" && route | grep "${NODE1_IPV4}"
    CHECK_RESULT $? 0 0 "check route failed!"
    route -n | grep -v "default" | grep "0.0.0.0"
    CHECK_RESULT $? 0 0 "check route -n failed!"
    route -e | grep -E "irtt|MSS|Window" 
    CHECK_RESULT $? 0 0 "check route -e failed!"
    route del default gw "${NODE1_IPV4}" && route | grep -v "${NODE1_IPV4}"
    CHECK_RESULT $? 0 0 "check route failed!"
    LOG_INFO "End to run net-tools test."
}

main "$@"
