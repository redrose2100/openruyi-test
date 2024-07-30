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
# @Date      :   2024-5-28
# @License   :   Mulan PSL v2
# @Desc      :   set max uid
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    grep "^maxuid:" /etc/passwd && userdel -rf maxuid
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    useradd maxuid
    LINE_NUMBER=$(grep -nw "UID_MAX" /etc/login.defs | awk -F ':' '{print $1}')
    sed -i "$LINE_NUMBER"s/60000/1000/g /etc/login.defs
    CHECK_RESULT $? 0 0 "Fail to set max uid."
    useradd maxuid-1 | grep "no more available UIDs"
    CHECK_RESULT $? 0 1 "Still has available UIDs."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    userdel -rf maxuid
    grep "^maxuid-1:" /etc/passwd && userdel -rf maxuid-1
    sed -i "$LINE_NUMBER"s/1000/60000/g /etc/login.defs
    LOG_INFO "End to restore the test environment."
}
main "$@"
