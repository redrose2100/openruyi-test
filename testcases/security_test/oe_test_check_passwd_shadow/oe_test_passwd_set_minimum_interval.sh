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
    cat << EOT > cannot_set_minimum_interval.sh
    #!/bin/bash
    user_name='set_minimum_interval5'
    old_passwd='juwh$^78'
    new_passwd='wihyb)%28'

    useradd -s /bin/bash \$user_name
    echo \$user_name:\$old_passwd |chpasswd
    passwd -n 5 \$user_name

    expect << EOF > getfile
    spawn su \$user_name
    send "passwd\\r"
    expect {
    "当前的密码：" {send "\$old_passwd\\r";exp_continue}
    "当前密码：" {send "\$old_passwd\\r";exp_continue}
    }
    send "exit\\r"
EOF
EOT
    cat << EOT > can_set_minimum_interval.sh
    #!/bin/bash
    user_name='set_minimum_interval5'
    old_passwd='juwh$^78'
    new_passwd='wihyb)%28'

    expect << EOF > can_set_getfile
    spawn su \$user_name
    send "passwd\\r"
    expect {
    "当前的密码：" {send "\$old_passwd\\r";exp_continue}
    "新的密码：" {send "\$new_passwd\\r";exp_continue}
    "重新输入新的密码：" {send "\$new_passwd\\r";exp_continue}
    }
    send "exit\\r"
EOF
EOT
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bash cannot_set_minimum_interval.sh
    grep -q "鉴定令牌操作错误" getfile
    CHECK_RESULT $? 0 0 "Change password successful"
    after_six_days=$(date -d "+6 day" +%Y%m%d)
    date -s "$after_six_days"
    CHECK_RESULT $? 0 0 "Set system's time failed"
    bash can_set_minimum_interval.sh
    grep -q "身份验证令牌已经成功更新" can_set_getfile
    CHECK_RESULT $? 0 0 "Change password failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf getfile can_set_getfile cannot_set_minimum_interval.sh can_set_minimum_interval.sh
    userdel set_minimum_interval5
    timedatectl set-ntp true
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
