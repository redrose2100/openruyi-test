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
#@Desc          :   set parameter [freq_service] cpufreq_gov test
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
    IFS=" " read -r -a available_governors <<< "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)"
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    echo > /var/log/eagle/eagle.log
    sed -i 's/cpufreq_gov =.*/cpufreq_gov = '"${available_governors[-1]}"'/' /etc/eagle/eagle_policy.ini	    
    SLEEP_WAIT 5
    grep "${available_governors[-1]}" /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
    CHECK_RESULT $? 0 0 "Check cpufreq_gov = ${available_governors[-1]} failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/cpufreq_gov =.*/cpufreq_gov = seep/' /etc/eagle/eagle_policy.ini	    
    SLEEP_WAIT 5
    grep -A1 "ERROR PWRAPI: SetCpuFreqGovernor failed. ret: 9" /var/log/eagle/eagle.log | grep -F "ERROR SERVICE_MGR: [libfreq_service.so] freq_service. set cpufreq gov to seep failed"
    CHECK_RESULT $? 0 0 "Check cpufreq_gov = seep failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/cpufreq_gov =.*/cpufreq_gov = test/' /etc/eagle/eagle_policy.ini	    
    SLEEP_WAIT 5
    grep -A1 "ERROR POLICY: Invalid cpufreq governor. item:  gov:test" /var/log/eagle/eagle.log | grep -F "ERROR POLICY: Policy Content Error: seg:[freq_service] item:cpufreq_gov value:test"
    CHECK_RESULT $? 0 0 "Check cpufreq_gov = test failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
