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
    chmod 400 /usr/lib64/oeAware-plugin/libthread_collector.so
    \cp -rf /etc/oeAware/config.yaml /etc/oeAware/config_ori.yaml
    sed -i '/enable_list/a\ - name: libthread_collector.so' /etc/oeAware/config.yaml
    systemctl restart oeaware
    SLEEP_WAIT 1
    grep "plugin libthread_collector.so cannot be enabled, because it does not exist" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "libthread_collector.so error exist in server log"
    oeawarectl -l libthread_collector.so | grep "Plugin loaded failed, because plugin file permission is not the specified permission"
    CHECK_RESULT $? 0 0 "Error: libthread_collector.so plugin loaded" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    chmod 440 /usr/lib64/oeAware-plugin/libthread_collector.so
    \cp -rf /etc/oeAware/config_ori.yaml /etc/oeAware/config.yaml
    systemctl restart oeaware
    rm -rf /etc/oeAware/config_ori.yaml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
