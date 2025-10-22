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
#@Date          :   2025-07-22
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager mysql-server"
    systemctl restart oeaware
    systemctl start mysqld
    cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
    sed -i '/cpu_part:.*/{N;s/.*/  cpu_part:\n    - 0xd01\n    - 0xd02/}' /etc/oeAware/analysis_config.yaml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis -t 3 > analysis.log 2>&1 
    grep "use micro-arch TidNo" analysis.log | grep "Please set bios conf"
    CHECK_RESULT $? 0 0 "Error: Check suggestion use micro-arch TidNoCmp failed"
    \cp -f /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    sed -i '/cpu_part:.*/{N;s/.*/  cpu_part:\n    - 0xd04\n    - 0xd03/}' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 > analysis.log 2>&1
    ! grep "use micro-arch TidNo" analysis.log | grep "Please set bios conf"
    CHECK_RESULT $? 0 0 "Error: Check no suggestion use micro-arch TidNoCmp failed"
    \cp -f /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    sed -i '/cpu_part:.*/{N;s/.*/cpu_part:\n    - 0xd01\n    - 0xd03/}' /etc/oeAware/analysis_config.yaml
    echo > /var/log/oeAware/server.log
    oeawarectl analysis -t 3 > analysis.log 2>&1
    SLEEP_WAIT 5
    ! grep "use micro-arch TidNo" analysis.log | grep "Please set bios conf" && grep "Missing or invalid 'cpu_part' node in config" /var/log/oeAware/server.log
    CHECK_RESULT $? 0 0 "Error: Check no suggestion use micro-arch TidNoCmp failed"
    \cp -f /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    sed -i '/cpu_part:.*/{N;s/.*/  cpu_part: - 0xd01 - 0xd02/}' /etc/oeAware/analysis_config.yaml
    echo > /var/log/oeAware/server.log
    SLEEP_WAIT 5
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "Error loading config file: yaml-cpp: error at line 24, column 13: illegal block entry" analysis.log
    CHECK_RESULT $? 0 0 "Error: Check loading config file: yaml-cpp: error failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf analysis.log
    mv -f /etc/oeAware/analysis_config.yaml_bak /etc/oeAware/analysis_config.yaml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
