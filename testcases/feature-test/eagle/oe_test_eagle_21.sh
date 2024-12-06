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
#@Desc          :   set parameter [sched_service] smart_grid_enable test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! test -f /sys/fs/cgroup/cpu/cpu.dynamic_affinity_mode; then
        echo "the environment is not support!"
        exit 0
    fi
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    IFS=" " read -r -a available_governors <<< "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)"
    sed -i 's/smart_grid_gov_enable =.*/smart_grid_gov_enable = 1/' /etc/eagle/eagle_policy.ini
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sed -i 's/smart_grid_enable =.*/smart_grid_enable = 0/' /etc/eagle/eagle_policy.ini
    sed -i 's/smart_grid_vip_gov =.*/smart_grid_vip_gov = '"${available_governors[-1]}"'/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "smart_grid-0: ${available_governors[-1]}" /sys/devices/system/cpu/cpufreq/smart_grid_governor
    CHECK_RESULT $? 1 0 "Check [sched_service] smart_grid_eable=0 failed"
    
    sed -i 's/smart_grid_enable =.*/smart_grid_enable = 1/' /etc/eagle/eagle_policy.ini
    sed -i 's/smart_grid_vip_gov =.*/smart_grid_vip_gov = '"${available_governors[-1]}"'/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "smart_grid-0: ${available_governors[-1]}" /sys/devices/system/cpu/cpufreq/smart_grid_governor
    CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_eable=1 failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/smart_grid_enable =.*/smart_grid_enable = -1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[sched_service] item:smart_grid_enable value:-1" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check [sched_service] smart_grid_eable=-1 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
