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

source "${OET_PATH}"/testcases/feature-test/oeaware/common/common.sh

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
    numanum=$(($(echo "${numa0}" | awk -F"-" '{print $2}')+1))
    sum=4
    num=3
    interval_num=$(echo "${numanum}/${num}-1" | bc)
    create_docker "${sum}" "${numa0}"
    cp /etc/oeAware/plugin/load_based_scheduling.yaml /etc/oeAware/plugin/load_based_scheduling.yaml_bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo "high_load: 0" > /etc/oeAware/plugin/load_based_scheduling.yaml
    oeawarectl -e load_based_scheduling_tune | grep "Instance enabled successfully"
    CHECK_RESULT $? 0 0 "Error: Check enable load_based_scheduling_tune failed"
    docker_load "${num}"
    SLEEP_WAIT 30 
    check_docker "${num}" "${interval_num}"
    dockerid=$(docker ps -a | grep docker_name4 | awk '{print $1}')
    file="/sys/fs/cgroup/cpuset/docker/${dockerid}*/cpuset.preferred_cpus"
    test -f "${file}" && test ! -s "${file}"
    CHECK_RESULT $? 0 0 "Error: Check enable load_based_scheduling_tune failed"
    oeawarectl -d load_based_scheduling_tune
    echo "high_load: 0.9" > /etc/oeAware/plugin/load_based_scheduling.yaml
    oeawarectl -e load_based_scheduling_tune
    SLEEP_WAIT 60
    check_docker "${num}" "${interval_num}"
    oeawarectl -d load_based_scheduling_tune
    echo "high_load: -0.1" > /etc/oeAware/plugin/load_based_scheduling.yaml
    oeawarectl -e load_based_scheduling_tune | grep -F "Instance enabled failed, because config error, high_load must be in [0,1]"
    CHECK_RESULT $? 0 0 "Error: Check high_load: -0.1 failed"
    echo "high_load: 1.2" > /etc/oeAware/plugin/load_based_scheduling.yaml
    oeawarectl -e load_based_scheduling_tune | grep -F "Instance enabled failed, because config error, high_load must be in [0,1]"
    CHECK_RESULT $? 0 0 "Error: Check high_load: 1.2 failed"
    echo "high_load: abc" > /etc/oeAware/plugin/load_based_scheduling.yaml
    oeawarectl -e load_based_scheduling_tune | grep "Instance enabled failed, because yaml-cpp: error at line 1, column 12: bad conversion"
    CHECK_RESULT $? 0 0 "Error: Check high_load: abc failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG="${LANG_OLD}"
    clean_docker
    mv -f /etc/oeAware/plugin/load_based_scheduling.yaml_bak /etc/oeAware/plugin/load_based_scheduling.yaml
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
