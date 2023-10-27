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
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Check ip tuntap
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL net-tools
    new_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1-3).120
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    # the help message cannot grep directly
    ip help &>ip_help.log
    grep -q "tuntap" ip_help.log
    CHECK_RESULT $? 0 0 "Check ip support tuntap failed."
    ip tuntap help &>ip_tuntap.log
    grep -q "tuntap" ip_tuntap.log
    CHECK_RESULT $? 0 0 "Check ip tuntap help failed."
    ip tuntap add dev tap0 mod tap
    CHECK_RESULT $? 0 0 "Add ip for tap0 failed."
    ifconfig tap0 "${new_ip}" up
    CHECK_RESULT $? 0 0 "Up tap0 failed."
    route add -host 172.168.128.0 dev tap0
    CHECK_RESULT $? 0 0 "Add rout for tap0 failed."
    ip tuntap del dev tap0 mod tap
    CHECK_RESULT $? 0 0 "Delete tap0 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f ip_help.log ip_tuntap.log
    LOG_INFO "End to restore the test environment."
}

main "$@"
