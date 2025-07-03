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
#@Date          :   2025-03-25
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    DNF_INSTALL "oeAware-manager numactl redis"
    systemctl start oeaware
    numa_nodes=$(lscpu | grep "NUMA node(s)" | awk '{print $3}')
    oeawarectl -i numafast
    systemctl start redis
    pid=$(pgrep -f redis)
    cp /etc/numafast.conf /etc/numafast.conf_bak
    echo -e "\n[net-affinity]\nreddis=${NODE1_NIC}" >> /etc/numafast.conf
    numa_node=$(cat /sys/class/net/"${NODE1_NIC}"/device/numa_node)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    numafast &
    SLEEP_WAIT 5
    task=$(taskset -p "${pid}")
    killall -9 numafast
    for i in $(seq 0 $((numa_nodes-1)))
    do
        echo "$i" > /sys/class/net/"${NODE1_NIC}"/device/numa_node
        numafast &
        SLEEP_WAIT 5
        taskset -p "${pid}" | grep -w "${task}"
        CHECK_RESULT $? 0 0 "Error: Check numafast failed"
        killall -9 numafast 
        SLEEP_WAIT 5
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/numafast.conf_bak /etc/numafast.conf
    echo "${numa_node}" > /sys/class/net/"${NODE1_NIC}"/device/numa_node
    rpm -e numafast
    export LANG="${LANG_OLD}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
