#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author: zhangpanting
# @Contact : 1768492250@qq.com
# @Date: 2024/4/23
# @License : Mulan PSL v2
# @Desc: Test ovs-delete-transient-ports.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL openvswitch
    systemctl start ovsdb-server.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution ovs-delete-transient-ports.service
    test_reload ovs-delete-transient-ports.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop ovsdb-server.service
    systemctl stop ovs-delete-transient-ports.service
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
