#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   1768492250@qq.com
# @Date      :   2026/01/14
# @License   :   Mulan PSL v2
# @Desc      :   Test mysqlrouter.service restart
# #############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL greatsql-mysql-router
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start mysqlrouter.service
    CHECK_RESULT $? 0 0 "Failed to start mysqlrouter service"
    systemctl status mysqlrouter.service | grep -q "Active: active"
    CHECK_RESULT $? 0 0 "mysqlrouter service is not active"
    systemctl restart mysqlrouter.service
    CHECK_RESULT $? 0 0 "Failed to restart mysqlrouter service"
    systemctl status mysqlrouter.service | grep -q "Active: active"
    CHECK_RESULT $? 0 0 "mysqlrouter service is not active after restart"
    systemctl stop mysqlrouter.service
    CHECK_RESULT $? 0 0 "Failed to stop mysqlrouter service"
    systemctl status mysqlrouter.service | grep -q "Active: inactive"
    CHECK_RESULT $? 0 0 "mysqlrouter service is still active after stop"
    mysqlrouter --help 2>&1 | grep -q -E "(MySQL Router|Usage)"
    CHECK_RESULT $? 0 0 "mysqlrouter command not working properly"
    test -f /etc/mysqlrouter/mysqlrouter.conf
    CHECK_RESULT $? 0 0 "mysqlrouter configuration file not found"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop mysqlrouter.service
    # shellcheck disable=SC2119
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main "$@"

