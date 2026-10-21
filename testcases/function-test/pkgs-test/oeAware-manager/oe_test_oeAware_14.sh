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
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    \cp -rf /etc/oeAware/config.yaml /etc/oeAware/config_ori.yaml
    chmod 777 /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 10
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 1 0 "service status is wrong" 
    /usr/bin/oeaware /etc/oeAware/config.yaml | grep "Insufficient permission on /etc/oeAware/config.yaml"
    CHECK_RESULT $? 0 0 "Error: config file permission" 

    chmod 640 /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 5
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 0 0 "service status is wrong" 

    chmod 400 /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 10
    systemctl status oeaware | grep "active (running)"
    CHECK_RESULT $? 1 0 "service status is wrong" 
    /usr/bin/oeaware /etc/oeAware/config.yaml | grep "Insufficient permission on /etc/oeAware/config.yaml"
    CHECK_RESULT $? 0 0 "Error: config file permission"  
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    chmod 640 /etc/oeAware/config.yaml
    systemctl restart oeaware
    rm -rf /etc/oeAware/config_ori.yaml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
