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
    DNF_INSTALL "oeAware-manager docker"
    systemctl start docker
    systemctl restart oeaware
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    numa0=$(lscpu | grep "NUMA node0" | awk '{print $4}')
    create_docker 1 "${numa0}"
    docker_load 1
    dockerid1=$(docker ps -a | grep docker_name1 | awk '{print $1}')
    SLEEP_WAIT 50 
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e load_based_scheduling_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check enable load_based_scheduling_tune failed"
    SLEEP_WAIT 3 
    grep "${numa0}" /sys/fs/cgroup/cpuset/docker/"${dockerid1}"*/cpuset.preferred_cpus 
    CHECK_RESULT $? 0 0 "Error: Check enable load_based_scheduling_tune failed"
    oeawarectl -d load_based_scheduling_tune | grep "Instance disabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check disable load_based_scheduling_tune failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG="${LANG_OLD}"
    clean_docker
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
