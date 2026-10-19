#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date          :   2025-09-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/testcases/function-test/feature-test/oeaware/common/common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager numactl"
    systemctl restart oeaware
    oeawarectl -i numafast
    cp /etc/oeAware/config.yaml /etc/oeAware/config.yaml_bak
    sed -i 's/log_level:.*/log_level: 0/' /etc/oeAware/config.yaml
    echo > /var/log/oeAware/server.log
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl --reload-conf | grep "Reload config successfully.log level changed from 2 to 0"
    CHECK_RESULT $? 0 0 "Error: Check set log_level: 0 failed"
    oeawarectl -e tune_numa_mem_access
    SLEEP_WAIT 5
    grep "============ Health Monitor Report ===========" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "Error: Check Health Monitor Report failed"
    oeawarectl -d tune_numa_mem_access
    sed -i 's/log_level:.*/log_level: 2/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf | grep "Reload config successfully.log level changed from 0 to 2"
    oeawarectl -e tune_numa_mem_access
    echo > /var/log/oeAware/server.log
    SLEEP_WAIT 5
    grep "============ Health Monitor Report ===========" /var/log/oeAware/server.log
    CHECK_RESULT $? 1 0 "Error: Check Health Monitor Report failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    oeawarectl -d tune_numa_mem_access
    mv -f /etc/oeAware/config.yaml_bak /etc/oeAware/config.yaml
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
