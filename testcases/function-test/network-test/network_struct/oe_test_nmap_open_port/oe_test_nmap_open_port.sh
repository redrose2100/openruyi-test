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
#@Desc      	:   Check open port
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL firewalld
    systemctl start firewalld
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    firewall-cmd --add-port=80/tcp --permanent
    CHECK_RESULT $? 0 0 "Open port 8080 failed."
    firewall-cmd --reload
    firewall-cmd --query-port=80/tcp | grep "yes"
    CHECK_RESULT $? 0 0 "Check port 8080 status open failed."
    firewall-cmd --remove-port=80/tcp --permanent
    CHECK_RESULT $? 0 0 "Close port 8080 failed."
    firewall-cmd --reload
    firewall-cmd --query-port=80/tcp | grep "no"
    CHECK_RESULT $? 0 0 "Check port 8080 status closed failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
