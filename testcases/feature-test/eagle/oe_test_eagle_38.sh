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
#@Date          :   2024-07-16
#@License       :   Mulan PSL v2
#@Desc          :   parameter restore test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! test -d /sys/fs/cgroup/cpu/watt_sched; then
        echo "the environment is not support!"
        exit 0
    fi
    watt_threshold_old=$(cat /proc/sys/kernel/sched_util_low_pct)
    watt_interval_ms_old=$(cat /sys/fs/cgroup/cpu/watt_sched/cpu.affinity_period_ms)
    watt_domain_mask_old=$(cat /sys/fs/cgroup/cpu/watt_sched/cpu.affinity_domain_mask)
    DNF_INSTALL eagle
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    sed -i 's/watt_threshold =.*/watt_threshold = 3/' /etc/eagle/eagle_policy.ini
    sed -i 's/watt_interval_ms =.*/watt_interval_ms = 360/' /etc/eagle/eagle_policy.ini
    sed -i 's/watt_domain_mask =.*/watt_domain_mask = 1/' /etc/eagle/eagle_policy.ini
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SLEEP_WAIT 5
    watt_threshold_cur=$(cat /proc/sys/kernel/sched_util_low_pct)
    watt_interval_ms_cur=$(cat /sys/fs/cgroup/cpu/watt_sched/cpu.affinity_period_ms)
    watt_domain_mask_cur=$(cat /sys/fs/cgroup/cpu/watt_sched/cpu.affinity_domain_mask)
    test "${watt_threshold_cur}" = 3 -a "${watt_interval_ms_cur}" = 360 -a "${watt_domain_mask_cur}" = 1
    CHECK_RESULT $? 0 0 "parameter watt_threshold、watt_interval_ms、watt_domain_mask set failed"
    systemctl stop eagle
    watt_threshold_cur=$(cat /proc/sys/kernel/sched_util_low_pct)
    watt_interval_ms_cur=$(cat /sys/fs/cgroup/cpu/watt_sched/cpu.affinity_period_ms)
    watt_domain_mask_cur=$(cat /sys/fs/cgroup/cpu/watt_sched/cpu.affinity_domain_mask)
    test "${watt_threshold_cur}" = "${watt_threshold_old}" -a "${watt_interval_ms_cur}" = "${watt_interval_ms_old}" -a "${watt_domain_mask_cur}" = "${watt_domain_mask_old}"
    CHECK_RESULT $? 0 0 "parameter watt_threshold、watt_interval_ms、watt_domain_mask restore failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
