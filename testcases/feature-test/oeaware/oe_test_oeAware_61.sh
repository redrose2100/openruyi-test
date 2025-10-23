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
    DNF_INSTALL "oeAware-manager"
    systemctl restart oeaware
    cp /etc/oeAware/analysis_config.yaml /etc/oeAware/analysis_config.yaml_bak
    sed -i 's/host_cpu_usage_threshold:.*/host_cpu_usage_threshold: 0/' /etc/oeAware/analysis_config.yaml
    sed -i 's/docker_cpu_usage_threshold:.*/docker_cpu_usage_threshold: 0/' /etc/oeAware/analysis_config.yaml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "Warn: analysis config" analysis.log
    CHECK_RESULT $? 1 0 "Error: Check host_cpu_usage_threshold docker_cpu_usage_threshold is 0 failed"
    sed -i 's/host_cpu_usage_threshold:.*/host_cpu_usage_threshold: 100/' /etc/oeAware/analysis_config.yaml
    sed -i 's/docker_cpu_usage_threshold:.*/docker_cpu_usage_threshold: 100/' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "Warn: analysis config" analysis.log
    CHECK_RESULT $? 1 0 "Error: Check host_cpu_usage_threshold docker_cpu_usage_threshold is 100 failed"
    sed -i 's/host_cpu_usage_threshold:.*/host_cpu_usage_threshold: -1/' /etc/oeAware/analysis_config.yaml
    sed -i 's/docker_cpu_usage_threshold:.*/docker_cpu_usage_threshold: -1/' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "Warn: analysis config" analysis.log
    CHECK_RESULT $? 0 0 "Error: Check host_cpu_usage_threshold docker_cpu_usage_threshold is -1 failed"
    sed -i 's/host_cpu_usage_threshold:.*/host_cpu_usage_threshold: 101/' /etc/oeAware/analysis_config.yaml
    sed -i 's/docker_cpu_usage_threshold:.*/docker_cpu_usage_threshold: 101/' /etc/oeAware/analysis_config.yaml
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "Warn: analysis config" analysis.log
    CHECK_RESULT $? 0 0 "Error: Check host_cpu_usage_threshold docker_cpu_usage_threshold is 101 failed"
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
