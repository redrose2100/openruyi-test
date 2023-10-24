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
#@Desc      	:   Create tap by tunctl
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    
    [[ ${NODE1_FRAME} -eq "aarch64" ]] && {
        LOG_INFO "tunctl doesn't support aarch64."
        exit 0
    }
    wget http://li.nux.ro/download/nux/misc/el7/x86_64/tunctl-1.5-12.el7.nux.x86_64.rpm
    dnf install tunctl-1.5-12.el7.nux.x86_64.rpm -y
    useradd testuser

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    tunctl
    CHECK_RESULT $? 0 0 "Create tap0 failed."
    ip a | grep -q tap0
    CHECK_RESULT $? 0 0 "Check tap0 failed."
    tunctl -u testuser
    CHECK_RESULT $? 0 0 "Create tap1 for testuser failed."
    ip a | grep -q tap1
    CHECK_RESULT $? 0 0 "Check tap1 failed."
    tunctl -d tap0
    CHECK_RESULT $? 0 0 "Delete tap0 failed."
    tunctl -d tap1
    CHECK_RESULT $? 0 0 "Delete tap1 failed."
    ip a | grep -q tap
    CHECK_RESULT $? 1 0 "Check tap is deleted failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    userdel testuser
    dnf remove tunctl -y
    rm -f tunctl-1.5-12.el7.nux.x86_64.rpm

    LOG_INFO "End to restore the test environment."
}

main "$@"
