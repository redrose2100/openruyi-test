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
#@Desc      	:   Check NetworkManager service
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart NetworkManager
    CHECK_RESULT $? 0 0 "Start NetworkManager service failed."
    systemctl status NetworkManager | grep "active"
    CHECK_RESULT $? 0 0 "Check NetworkManager service status failed."
    systemctl stop NetworkManager
    CHECK_RESULT $? 0 0 "Stop NetworkManager service failed."
    systemctl status NetworkManager | grep "inactive"
    CHECK_RESULT $? 0 0 "Check  NetworkManager service status failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl start NetworkManager
    LOG_INFO "End to restore the test environment."
}

main "$@"
