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
#@Desc          :   set parameter [freq_service] perf_loss_rate test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo > /var/log/eagle/eagle.log
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    sed -i "/\[freq_service\]/{N;s/.*/[freq_service]\nenable=1/}" /etc/eagle/eagle_policy.ini
    available_governor=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [[ "${available_governor}" =~ "seep" ]]; then
        echo > /var/log/eagle/eagle.log
        sed -i 's/cpufreq_gov =.*/cpufreq_gov = seep/' /etc/eagle/eagle_policy.ini	    
        sed -i 's/perf_loss_rate =.*/perf_loss_rate = -1/' /etc/eagle/eagle_policy.ini    
        SLEEP_WAIT 
        grep "-1" /sys/devices/system/cpu/cpufreq/"^policy*"/perf_loss_rate
        CHECK_RESULT $? 0 0 "Check perf_loss_rate = -1 failed"
        echo > /var/log/eagle/eagle.log
        sed -i 's/perf_loss_rate =.*/perf_loss_rate = 100/' /etc/eagle/eagle_policy.ini    
        SLEEP_WAIT 5
        grep "100" /sys/devices/system/cpu/cpufreq/"^policy*"/perf_loss_rate
        CHECK_RESULT $? 0 0 "Check perf_loss_rate = 100 failed"
    fi
    echo > /var/log/eagle/eagle.log
    sed -i 's/perf_loss_rate =.*/perf_loss_rate = -2/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[freq_service] item:perf_loss_rate value:-2" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check perf_loss_rate = -2 failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/perf_loss_rate =.*/perf_loss_rate = 101/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[freq_service] item:perf_loss_rate value:101" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check perf_loss_rate = 101 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
