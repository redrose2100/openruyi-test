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
# @Date      :   2022-12-16
# @License   :   Mulan PSL v2
# @Desc      :   Command ACL setfacl test mode
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test1
    echo test1:deepin12#$ | chpasswd
    touch /home/test1/testfile
    mkdir /home/test1/testdir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    setfacl --test -m u:test1:rw /home/test1/testdir
    setfacl --test -d -m u:test1:rw /home/test1/testdir
    CHECK_RESULT $? 0 0 "testdir test mode fail"   
    setfacl -m u:test1:rw /home/test1/testdir
    setfacl -d -m u:test1:rw /home/test1/testdir
    CHECK_RESULT $? 0 0 "testdir modify fail" 
    setfacl --test -m u:test1:rw /home/test1/testfile
    setfacl --test -d -m u:test1:rw /home/test1/testfile
    CHECK_RESULT $? 0 0 "testfile test mode fail" 
    setfacl -m u:test1:rw /home/test1/testfile
    CHECK_RESULT $? 0 0 "testfile set fail" 
    setfacl -d -m u:test1:rw /home/test1/testfile
    CHECK_RESULT $? 0 1 "testfile can not set success,please check"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
