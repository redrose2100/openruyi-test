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
#@Desc          :   set parameter [freq_service] sampling_rate_us test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! [ "${NODE1_FRAME}" = "aarch64" ] && [ "${NODE1_MACHINE}" = "physical" ]; then
       echo "eagle仅支持aarch64架构和物理机!"
       exit 255
    fi
    echo > /var/log/eagle/eagle.log
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    sed -i "/\[freq_service\]/{N;s/.*/[freq_service]\nenable=1/}" /etc/eagle/eagle_policy.ini
    cpufreq_gov=$(awk -F'=' '/^cpufreq_gov =/{gsub(/^[ ]+|[ ]+$/,"",$2);print $2}' /etc/eagle/eagle_policy.ini)
    sampling_rate=$(cat /sys/devices/system/cpu/cpufreq/"${cpufreq_gov}"/sampling_rate)
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/sampling_rate_us =.*/sampling_rate_us = 0/' /etc/eagle/eagle_policy.ini    
    SLEEP_WAIT 5
    grep "${sampling_rate}" /sys/devices/system/cpu/cpufreq/"${cpufreq_gov}"/sampling_rate
    CHECK_RESULT $? 0 0 "Check sampling_rate_us = 0 failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/sampling_rate_us =.*/sampling_rate_us = 10000000/' /etc/eagle/eagle_policy.ini    
    SLEEP_WAIT 5
    grep "10000000" /sys/devices/system/cpu/cpufreq/"${cpufreq_gov}"/sampling_rate
    CHECK_RESULT $? 0 0 "Check sampling_rate_us = 10000000 failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/sampling_rate_us =.*/sampling_rate_us = -1/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[freq_service] item:sampling_rate_us value:-1" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check sampling_rate_us = -1 failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/sampling_rate_us =.*/sampling_rate_us = 10000001/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[freq_service] item:sampling_rate_us value:10000001" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check sampling_rate_us = 10000001 failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
