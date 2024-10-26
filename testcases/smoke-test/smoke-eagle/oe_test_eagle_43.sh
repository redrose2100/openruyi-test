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
#@Author        :   jinye
#@Contact       :   jinye10@huawei.com
#@Date          :   2024-10-24
#@License       :   Mulan PSL v2
#@Desc          :   Set watt_sched_enable as 1 cannot set firstdomain test
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
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/watt_sched_enable =.*/watt_sched_enable = 1/' /etc/eagle/eagle_policy.ini
    sed -i 's/watt_first_domain =.*/watt_first_domain = 1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "SetWattFirstDomain failed." /var/log/eagle/eagle.log 
    CHECK_RESULT $? 0 0 "Check set first domain failed"
    sed -i 's/watt_sched_enable =.*/watt_sched_enable = 0/' /etc/eagle/eagle_policy.ini
    sed -i 's/watt_first_domain =.*/watt_first_domain = 1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "SetWattFirstDomain succeed." /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check set first domain failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
