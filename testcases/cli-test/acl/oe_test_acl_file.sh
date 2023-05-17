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
# @Date      :   2023-4-7
# @License   :   Mulan PSL v2
# @Desc      :   ACL permission for file
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test1
    useradd test2
    echo test1:deepin12#$ | chpasswd
    echo test2:deepin12#$ | chpasswd
    chmod 755 /home/test1
    chmod 755 /home/test2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    su - test1 -c "echo 'uname -a' > /home/test1/testfile"
    CHECK_RESULT $? 0 0 "test1 creat testfile fail" 
    su - test1 -c "chmod 000 /home/test1/testfile"
    CHECK_RESULT $? 0 0 "test1 set testfile permission fail" 

    su - test2 -c "bash /home/test1/testfile" 
    CHECK_RESULT $? 0 1 "test2 should be not execute testfile"  
    su - test2 -c "cat /home/test1/testfile"
    CHECK_RESULT $? 0 1 "test2 should be not read testfile"  

    su - test1 -c "setfacl -m u:test2:r-x /home/test1/testfile"
    CHECK_RESULT $? 0 0 "set permission which permit test2 to rx fail" 
    su - test2 -c "bash /home/test1/testfile"
    CHECK_RESULT $? 0 0 "test2 should be execute testfile" 
    su - test2 -c "cat /home/test1/testfile"
    CHECK_RESULT $? 0 0 "test2 should be read testfile" 
    su - test2 -c "echo 'beijing'>>/home/test1/testfile"
    CHECK_RESULT $? 0 1 "test2 should be not write testfile"  

    su - test1 -c "setfacl -m u:test2:rwx /home/test1/testfile"
    CHECK_RESULT $? 0 0 "set permission which permit test2 to rwx fail" 
    su - test2 -c "echo 'beijing'>>/home/test1/testfile"
    CHECK_RESULT $? 0 0 "test2 should be write testfile" 
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    userdel -rf test2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
