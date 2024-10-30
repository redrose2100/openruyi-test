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
#@Desc          :   set parameter [sched_service] watt_procs test
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
    echo "sleep 30" > test1.sh
    echo "sleep 30" > test2.sh
    LOG_INFO "End to to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sh test1.sh &
    pid=$(pgrep -f "sh test1.sh")
    sed -i 's/watt_procs =.*/watt_procs = all/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "${pid}" /sys/fs/cgroup/cpu/watt_sched/tasks
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_procs=all failed"
    kill -9 "${pid}"

    sh test1.sh &
    sh test2.sh &
    sed -i 's/watt_procs =.*/watt_procs = sh test1.sh|test2.sh/' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    pid1=$(pgrep -f "sh test1.sh")
    pid2=$(pgrep -f "sh test2.sh")
    grep "${pid1}" /sys/fs/cgroup/cpu/watt_sched/tasks && grep "${pid2}" /sys/fs/cgroup/cpu/watt_sched/tasks
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_procs=sh test1.sh|test2.sh failed"
    kill -9 "${pid1}" "${pid2}"
    
    sh test1.sh &
    pid=$(pgrep -f "sh test1.sh")
    sed -i 's/watt_procs =.*/watt_procs = /' /etc/eagle/eagle_policy.ini
    SLEEP_WAIT 5
    grep "${pid}" /sys/fs/cgroup/cpu/watt_sched/tasks
    CHECK_RESULT $? 0 0 "Check [sched_service] watt_procs= failed"
    kill -9 "${pid}"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test1.sh test2.sh
    mv -f /etc/eagle/eagle_policy.ini_bak /etc/eagle/eagle_policy.ini
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
