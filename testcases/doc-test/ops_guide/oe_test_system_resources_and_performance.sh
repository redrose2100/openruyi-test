#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-07-19
#@License       :   Mulan PSL v2
#@Desc          :   Monitor system resources and performance
#####################################
# shellcheck disable=SC1090,SC2009

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    Default_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "sysstat numactl"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # CPU
    uptime | grep "load average"
    CHECK_RESULT $? 0 0 "Failed to execute uptime"
    vmstat -h | grep "Usage:"
    CHECK_RESULT $? 0 0 "Failed to get the usage of vmstat"
    vmstat 1 -t 3 | grep "procs"
    CHECK_RESULT $? 0 0 "Failed to execute vmstat"
    sar -u 3 5 | grep "CPU"
    CHECK_RESULT $? 0 0 "Failed to execute sar"
    ps -le | grep "CMD"
    CHECK_RESULT $? 0 0 "Failed to execute ps -le"
    ps -l | grep "bash"
    CHECK_RESULT $? 0 0 "Failed to execute ps -l"
    top -n 1 -b | grep "CPU"
    CHECK_RESULT $? 0 0 "Failed to execute top"
    # Mem
    free -m | grep "Mem"
    CHECK_RESULT $? 0 0 "Failed to execute free"
    vmstat -a | grep "inact" | grep "active"
    CHECK_RESULT $? 0 0 "Failed to execute vmstat"
    sar -r 2 3 | grep "kbmemfree" | grep "kbmemused"
    CHECK_RESULT $? 0 0 "Failed to execute sar"
    numactl -H | grep "node distances"
    CHECK_RESULT $? 0 0 "Failed to execute numactl"
    numastat | grep "numa_hit"
    CHECK_RESULT $? 0 0 "Failed to execute numactl"
    # IO
    iostat -d -k -x 3 2 | grep "Device" | grep "r/s" | grep "w/s"
    CHECK_RESULT $? 0 0 "Failed to execute iostat"
    sar -d 3 5 | grep "DEV" | grep "tps" | grep "rkB/s"
    CHECK_RESULT $? 0 0 "Failed to execute sar"
    vmstat -d | grep "disk" | grep "IO"
    CHECK_RESULT $? 0 0 "Failed to execute vmstat"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$Default_LANG
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
