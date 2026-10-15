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
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2023/05/04
# @License   :   Mulan PSL v2
# @Desc      :   Test bird.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL bird
    service=bird.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution ${service}
    systemctl start ${service}
    sed -i 's\ExecStart=/usr/sbin/bird -f -u bird -g bird\ExecStart=/usr/sbin/bird -d\g' /usr/lib/systemd/system/bird.service
    systemctl daemon-reload
    systemctl reload ${service}
    CHECK_RESULT $? 0 0 "bird.service reload failed"
    systemctl status ${service} | grep "Active: active"
    CHECK_RESULT $? 0 0 "bird.service reload causes the service status to change"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i 's\ExecStart=/usr/sbin/bird -d\ExecStart=/usr/sbin/bird -f -u bird -g bird\g' /usr/lib/systemd/system/bird.service
    systemctl daemon-reload
    systemctl reload ${service}
    systemctl stop  ${service}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

