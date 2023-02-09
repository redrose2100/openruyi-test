#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/02/09
# @License   :   Mulan PSL v2
# @Desc      :   timedatectl命令设置日期和时间
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    timedatectl
    CHECK_RESULT $? 0 0 "The timedatectl command is unavailable"
    timedatectl set-ntp no
    CHECK_RESULT $? 0 0 "timedatectl cannot turn off automatic synchronization"
    timedatectl set-time '2019-08-14'
    timedatectl | grep "2019-08-14"
    CHECK_RESULT $? 0 0 "timedatectl Failed to modify the date"
    timedatectl set-time 15:57:24
    timedatectl | grep "15:57"
    CHECK_RESULT $? 0 0 "timedatectl Failed to change the time"
    timedatectl set-timezone Asia/Beijing
    timedatectl | grep "Asia/Beijing"
    CHECK_RESULT $? 0 0 "timedatectl Failed to change the time zone"
    timedatectl set-ntp yes
    sleep 120
    timedatectl | grep "System clock synchronized: yes"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "End to restore the test environment."
}

main "$@"
