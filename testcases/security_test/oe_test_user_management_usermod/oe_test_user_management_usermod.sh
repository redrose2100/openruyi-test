#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022-11-30
# @License   :   Mulan PSL v2
# @Desc      :   Command usermod
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd alice
    echo alice:deepin12#$ | chpasswd
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    usermod -u 1060 alice
    grep 1060 /etc/passwd
    CHECK_RESULT $? 0 0 "alice id is error "
    usermod -l newalice  alice
    CHECK_RESULT $? 0 0 "newalice is not existence "
    usermod -G wheel newalice
    id newalice | grep wheel	
    CHECK_RESULT $? 0 0 "newalice is not join group wheel "
    usermod -L newalice
    passwd -S newalice 	
    CHECK_RESULT $? 0 0 "newalice is unlock "
    usermod -U newalice	
    CHECK_RESULT $? 0 0 "newalice is still locked "  
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf newalice
    groupdel -f alice
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
