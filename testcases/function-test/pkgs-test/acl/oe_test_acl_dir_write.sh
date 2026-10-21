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
# @Date      :   2023-7-21
# @License   :   Mulan PSL v2
# @Desc      :   ACL dir write permission
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd ace
    useradd uos1
    echo ace:deepin12#$ | chpasswd
    echo uos1:deepin12#$ | chpasswd
    chmod 755 /home/uos1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    su - uos1 -c "mkdir /home/uos1/test115217"
    su - uos1 -c "chmod 000 /home/uos1/test115217"
    su - uos1 -c "cd /home/uos1/test115217"
    CHECK_RESULT $? 0 1 "uos1 should not have permission to enter" 
    su - uos1 -c "touch /home/uos1/test115217/testfile217"
    CHECK_RESULT $? 0 1 "uos1 should not have permission to creat"  
    su - uos1 -c "setfacl -m u:ace:-wx /home/uos1/test115217"
    CHECK_RESULT $? 0 0 "test115217 pemission set fail" 
    su - ace -c "cd /home/uos1/test115217"
    CHECK_RESULT $? 0 0 "ace enter test115217 fail" 
    su - ace -c "touch /home/uos1/test115217/testfile217"
    CHECK_RESULT $? 0 0 "ace creat file fail" 

    su - uos1 -c "setfacl -m u:ace:-w- /home/uos1/test115217"
    CHECK_RESULT $? 0 0 "test115217 pemission set fail" 	
    su - ace -c "cd /home/uos1/test115217"
    CHECK_RESULT $? 0 1 "uos1 should not have permission to enter test115217"
    su - ace -c "touch /home/uos1/test115217/testfile217"
    CHECK_RESULT $? 0 1 "uos1 should not have permission to creat file" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf ace
    userdel -rf uos1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
