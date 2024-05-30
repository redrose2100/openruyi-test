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
# @Date      :   2023-7-4
# @License   :   Mulan PSL v2
# @Desc      :   acl backup and recovery
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test1
    useradd test2
    mkdir testdir
    touch testfile
    chacl -b u::rw,g::rx,o::-,u:test1:rw,g:test1:rw,m::rwx u::rwx,g::r,o::-,u:test1:r,m::rwx testdir
    chacl u::rw,g::rx,o::-,u:test2:rw,g:test2:rw,m::rwx testfile
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    getfacl testdir > acl1.txt
    CHECK_RESULT $? 0 0 "backup testdir acl fail"
    setfacl -b testdir
    CHECK_RESULT $? 0 0 "delete testdir acl fail"
    setfacl --set-file=acl1.txt testdir  
    CHECK_RESULT $? 0 0 "recovery testdir acl  fail"
    getfacl testdir > acl1-1.txt
    CHECK_RESULT $? 0 0 "get testdir acl fail" 
    diff acl1.txt acl1-1.txt
    CHECK_RESULT $? 0 0 "not fully recovery testdir acl"

    getfacl testfile > acl2.txt
    CHECK_RESULT $? 0 0 "backup testfile acl fail"
    setfacl -b testfile
    CHECK_RESULT $? 0 0 "delete testfile acl fail"
    setfacl --set-file=acl2.txt testfile
    CHECK_RESULT $? 0 0 "recovery testfile acl  fail"
    getfacl testfile > acl2-2.txt
    CHECK_RESULT $? 0 0 "get testfile acl fail"
    diff acl2.txt acl2-2.txt
    CHECK_RESULT $? 0 0 "not fully recovery testfile acl"   
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    userdel -rf test2
    rm -rf testfile testdir acl*.txt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
