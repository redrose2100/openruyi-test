#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2022-09-06
# @License   :   Mulan PSL v2
# @Desc      :   yum rollback
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "zenity"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    if echo "${NODE1_OS_VERSION}" | grep -E "debian|velinux";then
        dpkg -s zenity | grep "install ok installed"
        CHECK_RESULT $? 0 0 "install fail"
        apt remove -y zenity && apt purge -y zenity
        CHECK_RESULT $? 0 0 "remove fail"
        dpkg -s zenity 2>&1 | grep "not installed"
        CHECK_RESULT $? 0 0 "remove fail"
        apt install -y zenity
        CHECK_RESULT $? 0 0 "install fail"
        dpkg -s zenity | grep "install ok installed"
        CHECK_RESULT $? 0 0 "install fail"
    else
        ID=$(yum history list | grep "install zenity" | awk 'NR==1 {print $1}')
        CHECK_RESULT $? 0 0 "install fail"
        yum history undo "$ID" -y
        CHECK_RESULT $? 0 0 "remove fail"
        rpm -qa | grep -w zenity
        CHECK_RESULT $? 0 1 "remove fail"
        yum history redo "$ID" -y
        CHECK_RESULT $? 0 0 "install fail"
        rpm -qa | grep -w zenity
        CHECK_RESULT $? 0 0 "install fail"
    fi
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
