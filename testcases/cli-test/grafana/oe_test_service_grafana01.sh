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
# @Author    :   wenjun
# @Contact   :   1009065695@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test grafana-server.service restart
# #############################################
# shellcheck disable=SC2119
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL grafana
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution grafana-server.service
    test_reload grafana-server.service
    systemctl is-active grafana-server.service > /dev/null
    CHECK_RESULT $? 0 0 "Check grafana-server service status failed"
    ss -tlnp | grep -q ":3000"
    CHECK_RESULT $? 0 0 "Check grafana-server port listening failed"
    [[ -d /usr/share/grafana ]]
    CHECK_RESULT $? 0 0 "Check grafana install directory failed"
    [[ -f /etc/grafana/grafana.ini ]]
    CHECK_RESULT $? 0 0 "Check grafana configuration file failed" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop grafana-server.service
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main "$@"

