#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lanyanling
# @Contact   :   lanyanling@uniontech.com
# @Date      :   2024-3-20
# @License   :   Mulan PSL v2
# @Desc      :   use passwd set the minimum password modification interval
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    cat << EOT > cannot_set_minimum_interval.sh
    #!/bin/bash
    user_name='set_minimum_interval10'
    old_passwd='juwh$^78'
    new_passwd='wihyb)%28'

    useradd -s /bin/bash \$user_name
    echo \$user_name:\$old_passwd |chpasswd
    passwd -n 5 \$user_name

    expect << EOF > getfile
    spawn su \$user_name
    send "passwd\\r"
    expect {
    "Current password*" {send "\$old_passwd\\r";exp_continue}
    "Current Password*" {send "\$old_passwd\\r";exp_continue}
    }
    send "exit\\r"
EOF
EOT
    cat << EOT > can_set_minimum_interval.sh
    #!/bin/bash
    user_name='set_minimum_interval10'
    old_passwd='juwh$^78'
    new_passwd='wihyb)%28'

    expect << EOF > can_set_getfile
    spawn su \$user_name
    send "passwd\\r"
    expect {
    "Current password*" {send "\$old_passwd\\r";exp_continue}
    "New password*" {send "\$new_passwd\\r";exp_continue}
    "Retype new password*" {send "\$new_passwd\\r";exp_continue}
    }
    send "exit\\r"
EOF
EOT
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bash cannot_set_minimum_interval.sh
    grep -q "Authentication token manipulation error" getfile
    CHECK_RESULT $? 0 0 "Change password successful"
    # 不能用 `date -s` 改系统时钟：mugen 的 SLEEP_WAIT 用 time.monotonic 之外的
    # 绝对时间计时，时钟向前跳变 6 天后被判定为 1800s 超时，用例直接判失败。
    # 最小间隔只看“上次修改日期”，改 chage 的最后改密日期即可，无需动系统时间。
    chage -d "$(date -d '-6 day' +%Y-%m-%d)" set_minimum_interval10
    CHECK_RESULT $? 0 0 "Set last password change date failed"
    bash can_set_minimum_interval.sh
    grep -q "all authentication tokens updated successfully" can_set_getfile
    CHECK_RESULT $? 0 0 "Change password failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    rm -rf getfile can_set_getfile cannot_set_minimum_interval.sh can_set_minimum_interval.sh
    userdel -rf set_minimum_interval10
    timedatectl set-ntp true
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
