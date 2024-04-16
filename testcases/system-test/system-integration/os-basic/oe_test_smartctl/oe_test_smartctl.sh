#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   luyan_uniontech
# @Contact   :   qinjiaxi@uniontech.com
# @Date      :   2024-03-29
# @License   :   Mulan PSL v2
# @Desc      :   test manpath
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "smartmontools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    smartctl -h
    CHECK_RESULT $?
    disk_name=$(lsblk|grep disk|awk '{print $1}')
    smartctl -a /dev/"$disk_name"
    CHECK_RESULT $?
    smartctl -H /dev/"$disk_name"
    CHECK_RESULT $?
    smartctl -A /dev/"$disk_name"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "smartmontools"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"