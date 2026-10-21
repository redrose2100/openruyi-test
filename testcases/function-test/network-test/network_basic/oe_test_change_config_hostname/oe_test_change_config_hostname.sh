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
#@Desc      	:   Modify config file to change hostname
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hostname" 2
    P_SSH_CMD --node 2 --cmd "mv /etc/hostname /etc/hostname.bak"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "hostname test.main
    echo 'test.main' > /etc/hostname"
    CHECK_RESULT $? 0 0 "Write /etc/hostname config failed."
    P_SSH_CMD --node 2 --cmd "uname -n | grep test.main"
    CHECK_RESULT $? 0 0 "Check hostname failed."
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    P_SSH_CMD --node 2 --cmd "uname -n | grep test.main"
    CHECK_RESULT $? 0 0 "Check hostname failed after reboot."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    P_SSH_CMD --node 2 --cmd "mv -f /etc/hostname.bak /etc/hostname"
    DNF_REMOVE "$@" 2
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    LOG_INFO "End to restore the test environment."
}

main "$@"
