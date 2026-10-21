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

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager numactl gcc-c++"
    systemctl restart oeaware
    oeawarectl -i numafast
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    numa0=$(lscpu | grep "NUMA node0" | awk '{print $4}')
    numanum=$(($(echo "${numa0}" | awk -F"-" '{print $2}')+1))
    socket1_start=$(lscpu | grep "NUMA node0" | awk '{print $4}' | awk -F'-' '{print $1}')
    socket1_end=$(lscpu | grep "NUMA node1" | awk '{print $4}' | awk -F'-' '{print $2}')
    socket2_start=$(lscpu | grep "NUMA node2" | awk '{print $4}' | awk -F'-' '{print $1}')
    socket2_end=$(lscpu | grep "NUMA node3" | awk '{print $4}' | awk -F'-' '{print $2}')
    cp /etc/numafast.yaml /etc/numafast.yaml_bak
    g++ common/test_load.cpp -o test_load -O2
    sed -i 's/min-numa-score:.*/min-numa-score: "999"/' /etc/numafast.yaml
    sed -i 's/max-numa-score:.*/max-numa-score: "1000"/' /etc/numafast.yaml
    sed -i 's/min-rx-ops-per-ms:.*/min-rx-ops-per-ms: "1"/' /etc/numafast.yaml
    sed -i 's/bind-socket:.*/bind-socket: "true"/' /etc/numafast.yaml
    sed -i 's/smt:.*/smt: "off"/' /etc/numafast.yaml
    echo '
  - name: "test_load"
    algorithm: "MigrateThreadsToOneSocketAuto"' >> /etc/numafast.yaml
    num1=$(echo "scale=0;(${numanum} * 2.5 + 0.5)/1" | bc)
    num2=$(echo "scale=0;(${numanum} * 1.2 + 0.5)/1" | bc)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e tune_numa_mem_access
    ./test_load "${num1}" &
    SLEEP_WAIT 120
    taskset -pac "$(pidof test_load)" | grep "current affinity list: " | grep -E "${socket1_start}-${socket1_end}|${socket2_start}-${socket2_end}"
    CHECK_RESULT $? 0 0 "Error: Check socket bind failed" 
    pkill -9 test_load
    ./test_load 0 1000 &
    SLEEP_WAIT 120
    taskset -pac "$(pidof test_load)" | grep "current affinity list: " | grep -E "${socket1_start}-${socket1_end}|${socket2_start}-${socket2_end}"
    CHECK_RESULT $? 1 0 "Error: Check not socket bind failed" 
    pkill -9 test_load
    ./test_load 0 "${num2}" &
    SLEEP_WAIT 120    
    taskset -pac "$(pidof test_load)" | grep "current affinity list: " | grep -E "${socket1_start}-${socket1_end}|${socket2_start}-${socket2_end}"
    CHECK_RESULT $? 1 0 "Error: Check not socket bind failed" 
    pkill -9 test_load
    ./test_load "${num2}" &
    SLEEP_WAIT 120    
    taskset -pac "$(pidof test_load)" | grep "current affinity list: " | grep -E "${socket1_start}-${socket1_end}|${socket2_start}-${socket2_end}"
    CHECK_RESULT $? 1 0 "Error: Check not socket bind failed" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    oeawarectl -d tune_numa_mem_access
    pkill -9 test_load
    export LANG="${LANG_OLD}"
    mv -f /etc/numafast.yaml_bak /etc/numafast.yaml
    rm -rf test_load
    rpm -e numafast
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
