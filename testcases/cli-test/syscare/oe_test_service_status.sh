#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linmengmeng
# @Contact   :   linmengmeng@huawei.com
# @Date      :   2024/10/26
# @License   :   Mulan PSL v2
# @Desc      :   Test syscare.service status
# #############################################
# shellcheck disable=SC2120

source "$OET_PATH/testcases/cli-test/syscare/common/common_syscare.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "syscare syscare-build"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "syscare service test"
    systemctl start syscare.service
    systemctl status syscare.service | grep -w 'active'
    CHECK_RESULT $? 0 0 "syscare-service status is not active"
    systemctl stop syscare.service
    systemctl status syscare.service | grep -w 'inactive'
    CHECK_RESULT $? 0 0 "syscare-service status is not inactive"
    systemctl restart syscare.service
    systemctl status syscare.service | grep -w 'active'
    CHECK_RESULT $? 0 0 "syscare-service status is not active"


    LOG_INFO "remove syscare & upatch"
    DNF_REMOVE "$@"
    systemctl status syscare.service
    CHECK_RESULT $? 0 1 "syscare-service still exist"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
