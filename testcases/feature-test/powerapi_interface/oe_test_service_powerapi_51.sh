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
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2024-03-15
#@License       :   Mulan PSL v2
#@Desc          :   pwrapis.service restart test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_MACHINE}" != "physical" ]; then
        LOG_INFO "The environment does not support testing"
        exit 0
    fi
    DNF_INSTALL "powerapi-devel"
    sock_file="/test/pwrserver.sock"
    cp /etc/sysconfig/pwrapis/pwrapis_config.ini /etc/sysconfig/pwrapis/pwrapis_config.ini_bak
    sed -i 's#sock_file=.*#sock_file='"${sock_file}"'#' /etc/sysconfig/pwrapis/pwrapis_config.ini
    cat /etc/sysconfig/pwrapis/pwrapis_config.ini
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl stop pwrapis.service
    systemctl status pwrapis.service | grep "Active: inactive" 
    CHECK_RESULT $? 0 0 "pwrapis.service stop failed"
    systemctl start pwrapis.service
    systemctl status pwrapis.service | grep "Active: active" 
    CHECK_RESULT $? 0 0 "pwrapis.service start failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/sysconfig/pwrapis/pwrapis_config.ini_bak /etc/sysconfig/pwrapis/pwrapis_config.ini
    systemctl restart pwrapis.service
    DNF_REMOVE "$@"
    rm -rf /test pwrclient.sock
    LOG_INFO "End to restore the test environment."
}

main "$@"
