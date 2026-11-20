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
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.04-27
# @License   :   Mulan PSL v2
# @Desc      :   Use the timedatectl command to set the time
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    timedatectl set-ntp no
    SLEEP_WAIT 5
    # 用 timedatectl show / date 取值，避免依赖固定的输出行号和字段位置
    localzone=$(timedatectl show -p Timezone --value 2>/dev/null)
    [ -n "${localzone}" ] || localzone=$(timedatectl | awk -F': *' '/Time zone/{print $2}' | awk '{print $1}')
    current_time=$(date '+%Y-%m-%d %H:%M:%S')
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    timedatectl | grep "Local time"
    CHECK_RESULT $?
    timedatectl set-ntp yes
    CHECK_RESULT $?
    SLEEP_WAIT 5
    timedatectl | grep "NTP service" | grep " active"
    CHECK_RESULT $?
    timedatectl set-ntp no
    SLEEP_WAIT 5
    # systemd 拒绝把时钟设置到编译时间之前，因此使用相对当前时间的将来时间点
    target_date=$(date -d '+2 days' '+%Y-%m-%d')
    timedatectl set-time "${target_date}"
    SLEEP_WAIT 5
    CHECK_RESULT $?
    timedatectl | grep "Local time" | grep "${target_date}"
    CHECK_RESULT $?
    timedatectl set-time 03:04:05
    SLEEP_WAIT 5
    CHECK_RESULT $?
    timedatectl | grep "Local time" | grep "03:04"
    CHECK_RESULT $?
    # Asia/Beijing 不是 tzdata 中的合法时区，从 list-timezones 里取一个真实存在的
    ret=$(timedatectl list-timezones | grep -c "^Asia/")
    CHECK_RESULT "$ret" 0 1
    test_zone=$(timedatectl list-timezones | grep "^Asia/" | head -n 1)
    timedatectl set-timezone "${test_zone}"
    timedatectl | grep "${test_zone}"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # 恢复现场失败不应影响用例结果
    timedatectl set-ntp no || true
    timedatectl set-time "${current_time}" || true
    [ -n "${localzone}" ] && timedatectl set-timezone "${localzone}" || true
    timedatectl set-ntp yes || true
    LOG_INFO "Finish environment cleanup."
}

main "$@"
