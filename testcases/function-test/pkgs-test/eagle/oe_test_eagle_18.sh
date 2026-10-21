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
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2024-10-09
#@License       :   Mulan PSL v2
#@Desc          :   set parameter [sched_service] watt_domain_mask test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ]; then
       echo "eagle仅支持aarch64架构和物理机!"
       exit 255
    fi
    if ! test -d /sys/fs/cgroup/cpu/watt_sched; then
        echo "the environment is not support!"
        exit 0
    fi
    DNF_INSTALL "eagle"
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    numa_nodes=$(lscpu | grep "NUMA node(s)" | awk '{print $3}')
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_domain_mask =.*/watt_domain_mask = 0/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "SetProcWattAttrs" /var/log/eagle/eagle.log 
    CHECK_RESULT $? 1 0 "Check [sched_service] watt_domain_mask = 0 failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_domain_mask =.*/watt_domain_mask = '$((2**numa_nodes -1))'/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "SetProcWattAttrs succeed" /var/log/eagle/eagle.log 
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_domain_mask = $((2**numa_nodes -1)) failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_domain_mask =.*/watt_domain_mask = -1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[sched_service] item:watt_domain_mask value:-1" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_domain_mask = -1 failed"

    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_domain_mask =.*/watt_domain_mask = '$((2**numa_nodes))'/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[sched_service] item:watt_domain_mask value:$((2**numa_nodes))" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_domain_mask = $((2**numa_nodes)) failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    export LANG="${LANG_OLD}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
