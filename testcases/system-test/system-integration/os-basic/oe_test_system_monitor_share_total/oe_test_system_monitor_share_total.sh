#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   system monitor share total
# ############################################
# shellcheck disable=SC2154
source "${OET_PATH}/testcases/system-test/system-integration/os-basic/common/disk_lib.sh"

function config_params() {
    LOG_INFO "Start to config the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    check_free_disk
    LOG_INFO "Start to config the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sudo ipcs -m | grep "Shared Memory Segments"
    CHECK_RESULT $?
    ps -eo 'stat,pid,comm,args,pcpu' | sed -n 1p | awk -F " " '{print$1}' | grep "STAT"
    CHECK_RESULT $?
    ps -eo 'pcpu,pid,comm,args' | sort -rk1 | sed -n 1p | awk -F " " '{print$1}' | grep "%CPU"
    CHECK_RESULT $?
    ps -eo 'pmem,pid,comm,args' | sort -rk1 | sed -n 1p | awk -F " " '{print$1}' | grep "%MEM"
    CHECK_RESULT $?
    echo mq-deadline >/sys/block/"${local_disk}"/queue/scheduler
    grep '\[mq-deadline\]' /sys/block/"${local_disk}"/queue/scheduler
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
