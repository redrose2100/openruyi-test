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
#@Desc          :   set parameter [sched_service] watt_interval_ms test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! test -d /sys/fs/cgroup/cpu/watt_sched; then
        echo "the environment is not support!"
        exit 0
    fi
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_interval_ms =.*/watt_interval_ms = 0/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "SetProcWattAttrs" /var/log/eagle/eagle.log 
    CHECK_RESULT $? 1 0 "Check [sched_service] watt_interval_ms = 0 failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_interval_ms =.*/watt_interval_ms = 3600000/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "SetProcWattAttrs succeed" /var/log/eagle/eagle.log 
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_interval_ms = 3600000 failed"
    
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_interval_ms =.*/watt_interval_ms = -1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[sched_service] item:watt_interval_ms value:-1" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_interval_ms = -1 failed"

    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_interval_ms =.*/watt_interval_ms = 3600001/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[sched_service] item:watt_interval_ms value:3600001" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_interval_ms = 3600001 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
