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
#@Desc          :   set parameter [idle_service] cpuidle_gov test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo > /var/log/eagle/eagle.log
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    sed -i "/\[idle_service\]/{N;s/.*/[idle_service]\nenable=1/}" /etc/eagle/eagle_policy.ini
    IFS=" " read -r -a available_governors <<< "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)"
    SLEEP_WAIT 5
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if test -d /sys/devices/system/cpu/cpu0/cpuidle; then
        sed -i 's/cpuidle_gov =.*/cpuidle_gov = '"${available_governors[-1]}"'/' /etc/eagle/eagle_policy.ini
        SLEEP_WAIT 5
        grep "SetCpuIdleGov succeed" /var/log/eagle/eagle.log
        CHECK_RESULT $? 0 0 "Check [idle_service] cpuidle_gov config exists governor failed"
        echo > /var/log/eagle/eagle.log
        sed -i 's/cpuidle_gov =.*/cpuidle_gov = test/' /etc/eagle/eagle_policy.ini
        SLEEP_WAIT 5
        grep -F "Policy Content Error: seg:[idle_service] item:cpuidle_gov value:test" /var/log/eagle/eagle.log
        CHECK_RESULT $? 0 0 "Check [idle_service] cpuidle_gov = test failed"
    else
	grep "GetCpuIdleGov failed. ret: 15" /var/log/eagle/eagle.log
        CHECK_RESULT $? 0 0 "Check CpuIdleGov failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
