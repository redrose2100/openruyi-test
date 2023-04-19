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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-4-19
# @License   :   Mulan PSL v2
# @Desc      :   User Management using&modify username&UID include previously used and now exist
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd -u 1010 test1
    useradd -u 1020 xiao1
    useradd -u 1030 tom1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    useradd test1
    CHECK_RESULT $? 0 1 "test1 could not be created because test1 is already existed" 
    userdel -rf test1
    CHECK_RESULT $? 0 0 "test1 delete fail" 
    useradd test1
    CHECK_RESULT $? 0 0 "creating test1 fail" 

    useradd -u 1020 test2
    CHECK_RESULT $? 0 1 "test2 could not be created because UIS 1020 is already used" 
    userdel -rf xiao1
    CHECK_RESULT $? 0 0 "test1 delete fail" 
    useradd -u 1020 test2
    CHECK_RESULT $? 0 0 "creating test2 with UID 1020 fail" 

    usermod -l test2 tom1
    CHECK_RESULT $? 0 1 "tom1 name could not be modified because test2 is already used " 
    userdel -rf test2
    CHECK_RESULT $? 0 0 "test2 delete fail" 
    usermod -l test2 tom1
    CHECK_RESULT $? 0 0 "modify tom1 name to test2 fail" 
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    userdel -rf test2
    groupdel -f tom1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
