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

    # openRuyi 适配（mugen 框架约束）：mugen 用系统墙钟计算用例已运行时长
    # （libs/locallibs/sleep_wait.py: remaining = TIMEOUT - (time.time() - start)），
    # 一旦把时间向前大幅跳变（例：凌晨执行 date -s 9:30:00 前跳 9 小时），
    # 剩余时间立即变为负数，框架会在下一轮循环直接判 "timed out after 1800 seconds"
    # 并 SIGKILL 整个用例进程组（本次报告即此现象，断言本身其实已通过）。
    # 因此这里不再改动绝对时间：
    #   1) date -s 的设置能力用「以 epoch 回退 90 秒 → 校验回显 → 立即恢复」验证，
    #      墙钟偏移始终只有 90 秒，远小于超时阈值；
    #   2) 2015-02-04（星期三）的时间解析/格式化断言改为只读的 date -d 验证；
    #   3) RTC 断言只做 hwclock -w（把当前系统时间写入 RTC，不改系统时间）后
    #      与系统时间比对，且在没有 RTC 设备的环境下跳过。
    epoch_before=$(date +%s)
    target_epoch=$((epoch_before - 90))
    date -s "@${target_epoch}" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "date -s failed"
    now_epoch=$(date +%s)
    delta=$((now_epoch > target_epoch ? now_epoch - target_epoch : target_epoch - now_epoch))
    test "${delta}" -le 5
    CHECK_RESULT $? 0 0 "date -s did not take effect (delta=${delta}s)"
    date -s "@${epoch_before}" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "restore system time failed"

    date -d "2015-02-04 9:30:00" | grep "9:30:00" | grep 2015 | grep -i feb | grep -i wed
    CHECK_RESULT $? 0 0 "date -d 2015-02-04 9:30:00 failed"

    if hwclock --show >/dev/null 2>&1; then
        hwclock -w
        CHECK_RESULT $? 0 0 "hwclock -w failed"
        rtc_epoch=$(date -d "$(hwclock --show | sed 's/  .*//')" +%s 2>/dev/null)
        sys_epoch=$(date +%s)
        if [ -n "${rtc_epoch}" ]; then
            delta=$((sys_epoch > rtc_epoch ? sys_epoch - rtc_epoch : rtc_epoch - sys_epoch))
            test "${delta}" -le 120
            CHECK_RESULT $? 0 0 "RTC is not consistent with system clock"
        else
            LOG_WARN "Unable to parse hwclock output, skip RTC consistency check."
        fi
    else
        LOG_WARN "No RTC device available, skip hwclock check."
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # 用例已自行恢复系统时间，这里仅在必要时把时间校正回 pre_test 记录的基准点。
    date -s "$time" >/dev/null 2>&1
    export LANG=${OLD_LANG}
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
