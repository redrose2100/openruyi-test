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
#@Date          :   2024-06-06
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
    sed -i '/enable_list/a\ - name: libthread_scenario.so' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 3
    oeawarectl -q | grep "thread_scenario(available, running, count: 1)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"

    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    sed -i '/enable_list/a\ - name: libsystem_collector.so\n - name: libthread_scenario.so' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 3
    oeawarectl -q | grep "thread_scenario(available, running, count: 1)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"
    oeawarectl -q | grep -Pz "thread_collector\(available, running, count: 1\)[\S\s]*kernel_config\(available, close, count: 1\)[\S\s]*command_collector\(available, running, count: 1\)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"
 
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    sed -i '/enable_list/a\ - name: libsystem_collector.so\n   instances:\n      - thread_collector\n      - command_collector ' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 3
    oeawarectl -q | grep -Pz "thread_collector\(available, running, count: 1\)[\S\s]*kernel_config\(available, close, count: 0\)[\S\s]*command_collector\(available, running, count: 1\)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"
    
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    sed -i '/enable_list/a\ - name: libsystem_collector.so\n   instances:\n      - thread_collector\n      - command_collector\n      - kernel_config' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 3
    oeawarectl -q | grep -Pz "thread_collector\(available, running, count: 1\)[\S\s]*kernel_config\(available, close, count: 1\)[\S\s]*command_collector\(available, running, count: 1\)"
    CHECK_RESULT $? 0 0 "restart oeaware failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    DNF_REMOVE "$@"
    rm -rf /etc/oeAware/config_ori.yaml
    LOG_INFO "End to restore the test environment."
}

main "$@"
