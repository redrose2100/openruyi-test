#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2025/05/30
# @License   :   Mulan PSL v2
# @Desc      :   Test deepin-anything-tool.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL deepin-anything-server
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # 检查服务状态
    LOG_INFO "Check if the service is running properly."
    systemctl start deepin-anything-tool.service
    systemctl status deepin-anything-tool.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "Failed to start deepin-anything-tool service"

    test_execution deepin-anything-tool.service
    test_reload deepin-anything-tool.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop deepin-anything-tool.service
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}


main "$@"

