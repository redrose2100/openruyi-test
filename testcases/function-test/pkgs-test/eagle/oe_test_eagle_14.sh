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
#@Desc          :   set parameter [sched_service] sched_lib test
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
    echo > /var/log/eagle/eagle.log
    DNF_INSTALL "eagle"
    cp /etc/eagle/eagle_policy.ini /etc/eagle/eagle_policy.ini_bak
    SLEEP_WAIT 5
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grep "sched_service initialized" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check sched_lib default config failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/sched_lib =.*/sched_lib = test.so/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep -F "Policy Content Error: seg:[sched_service] item:sched_lib value:test.so" /var/log/eagle/eagle.log
    CHECK_RESULT $? 0 0 "Check sched_lib = test.so failed"
    echo > /var/log/eagle/eagle.log
    sed -i 's/sched_lib =.*/sched_lib = libidle_service.so/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "sched_service initialized" /var/log/eagle/eagle.log
    CHECK_RESULT $? 1 0 "Check sched_lib = libidle_service.so failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
