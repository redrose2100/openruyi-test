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
# @Author    :   aliceye666	wangxiaorou
# @Contact   :   yezhifen@uniontech.com	wangxiaorou@uniontech.com
# @Date      :   2022-12-15	2023-04-04
# @License   :   Mulan PSL v2
# @Desc      :   Command id
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    id account1 && userdel -rf account1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    id
    CHECK_RESULT $? 0 0 "id cmd fail"
    id -g
    CHECK_RESULT $? 0 0 "参数g不支持"
    id -G
    CHECK_RESULT $? 0 0 "参数G不支持" 
    id --help 
    CHECK_RESULT $? 0 0 "id help fail" 
    id --version
    CHECK_RESULT $? 0 0 "get version info" 

    id account1
    CHECK_RESULT $? 0 1 "get invalid account info" 
    useradd -G wheel account1
    id account1
    CHECK_RESULT $? 0 0 "get valid account info" 
    CHECK_RESULT "$(id -G -n account1)" "account1 wheel" 0 "get groups name info"
    CHECK_RESULT "$(id -g -n account1)" "account1" 0 "get group name info"
    CHECK_RESULT "$(id -u -n account1)" "account1" 0 "get user name info"
    CHECK_RESULT "$(id -G -r account1 |awk '{print $2}')" "10" 0 "get groups real id info"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    id account1 && userdel -rf account1
    LOG_INFO "End to restore the test environment."
}

main "$@"

