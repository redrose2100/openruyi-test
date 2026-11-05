#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Date command line test
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    time=$(date "+%Y-%m-%d %H:%M:%S")
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    date01=$(date | awk -F ' ' '{print $1,$2,$3}')
    date -d 2020-01-01
    date02=$(date | awk -F ' ' '{print $1,$2,$3}')
    test "$date01"x = "$date02"x
    CHECK_RESULT $?
    # 注意：date -s 会改变系统时间。框架的超时检测基于系统 epoch 时间，
    # 若修改后系统时间大幅前跳（如凌晨执行时 date -s 9:30:00），会跨过
    # "开始时刻+超时阈值"被框架立即误判超时。因此每次修改后立即恢复真实时间。
    date -s "9:30:00" | grep "9:30:00"
    CHECK_RESULT $?
    date -s "$time"
    hwclock -w
    date -s "2015-02-04 9:30:00" | grep "9:30:00" | grep 2015 | grep -i feb | grep -i wed
    CHECK_RESULT $?
    date -s "$time"
    hwclock -w
    # 最后一段：验证系统时间写回硬件时钟（RTC）后，RTC 保持 2015-02-04。
    # 断言完成后再把系统时间与 RTC 恢复到真实时间，避免后续用例受影响。
    date -s "2015-02-04 9:30:00"
    hwclock -w
    timedatectl | grep -E 'rtc time|RTC time:' | grep "2015-02-04"
    CHECK_RESULT $?
    date -s "$time"
    hwclock -w
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    date -s "$time"
    hwclock -w
    export LANG=${OLD_LANG}
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
