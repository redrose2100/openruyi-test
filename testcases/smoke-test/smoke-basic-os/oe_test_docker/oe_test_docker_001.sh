#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yujian
# @Contact   :   yujian@uniontech.com
# @Date      :   2024/03/26
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of sshd
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl status docker | grep running
    CHECK_RESULT $? 0 0 "Failed to check docker"
    systemctl restart docker
    CHECK_RESULT $? 0 0 "Failed to restart docker"
    systemctl status docker | grep running
    CHECK_RESULT $? 0 0 "Failed to check docker"
    systemctl enable docker |grep enable
    CHECK_RESULT $? 0 0 "Failed to enabled docker"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "End to restore the test environment."
}

main "$@"
