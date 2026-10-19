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

source "${OET_PATH}"/testcases/function-test/pkgs-test/oeAware-manager/common/common.sh

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
    logfile="/var/log/oeAware/server.log"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep "log_level: 2" /etc/oeAware/config.yaml
    CHECK_RESULT $? 0 0 "Error: Check default log_level failed"
    sed -i 's/log_level:.*/log_level: 0/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf
    echo > "${logfile}"
    oeawarectl -e tune_numa_mem_access
    oeawarectl -e tune_numa_mem_access -cmd "-w t"
    SLEEP_WAIT 3
    grep "TRACE" "${logfile}" && grep "DEBUG" "${logfile}" && grep "INFO" "${logfile}" && grep "WARN" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log_level is 0 include relation failed"
    sed -i 's/log_level:.*/log_level: 1/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf
    echo > "${logfile}"
    oeawarectl -e tune_numa_mem_access -cmd "-w t"
    SLEEP_WAIT 3
    grep "DEBUG" "${logfile}" && grep "INFO" "${logfile}" && grep "WARN" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log_level is 1 include relation failed"
    oeawarectl -d tune_numa_mem_access
    sed -i 's/log_level:.*/log_level: 2/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf
    echo > "${logfile}"
    oeawarectl -e tune_numa_mem_access -cmd "-w t"
    SLEEP_WAIT 3
    grep "INFO" "${logfile}" && grep "WARN" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log_level is 2 include relation failed"
    sed -i 's/log_level:.*/log_level: 3/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf
    echo > "${logfile}"
    oeawarectl -e tune_numa_mem_access -cmd "-w t"
    SLEEP_WAIT 3
    grep "WARN" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log_level is 3 include relation failed"
    sed -i 's/log_level:.*/log_level: 7/' /etc/oeAware/config.yaml
    oeawarectl --reload-conf | grep -F "Reload config failed, because log level is out of range, must be in [0, 5]"
    CHECK_RESULT $? 0 0 "Error: Check set log_level is not exists failed"
    echo > "${logfile}"
    oeawarectl -e tune_numa_mem_access -cmd "-w t"
    SLEEP_WAIT 3
    grep "WARN" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log_level is 3 include relation failed"
    sed -i 's/log_level:.*/log_level: /' /etc/oeAware/config.yaml
    oeawarectl --reload-conf | grep "Reload config failed, because config file format error"
    CHECK_RESULT $? 0 0 "Error: Check log_level is not set failed"
    echo > "${logfile}"
    oeawarectl -e tune_numa_mem_access -cmd "-w t"
    SLEEP_WAIT 3
    grep "WARN" "${logfile}"
    CHECK_RESULT $? 0 0 "Error: Check log_level is 3 include relation failed"
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
