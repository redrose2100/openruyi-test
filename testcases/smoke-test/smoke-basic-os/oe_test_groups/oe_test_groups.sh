#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangliang
#@Contact   	:   wangliang4@uniontech.com
#@Date      	:   2024-09-23
#@License   	:   Mulan PSL v2
#@Desc      	:   test groups
#####################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    current_user=$(whoami)
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    current_group=$(grep "$current_user" /etc/group | awk -F":" '{print $1}' | head -n 1)
    groups
    CHECK_RESULT $? 0 0 "test groups fail"
    user_group=$(groups)
    test "${user_group}" == "${current_group}"
    CHECK_RESULT $? 0 0 "test current user group fail"

    useradd test_user1
    groups test_user1
    CHECK_RESULT $? 0 0 "test test_user1 groups fail"
    user_group1=$(grep "test_user1" /etc/group | awk -F":" '{print $1}')
    user_group=$(groups test_user1 | awk '{print $NF}')
    test "${user_group}" == "${user_group1}"
    CHECK_RESULT $? 0 0 "test test_user1 group fail"

    useradd -m -g root test_user2
    groups test_user2
    CHECK_RESULT $? 0 0 "test test_user2 groups fail"
    user_group=$(groups test_user2 | awk '{print $NF}')
    test "${user_group}" == "root"
    CHECK_RESULT $? 0 0 "test test_user2 group fail"

    groups --help
    CHECK_RESULT $? 0 0 "test args --help fail"
    groups --version
    CHECK_RESULT $? 0 0 "test args --version fail"
    LOG_INFO "Finish test."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    userdel -r test_user1
    userdel -r test_user2
    unset current_user
    unset user_group1
    unset user_group
    LOG_INFO "Finish restoring environment."
}

main "$@"
