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
# @Date      :   2023-8-4
# @License   :   Mulan PSL v2
# @Desc      :   ACL file authorization
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test 
    useradd test1
    useradd test2
    useradd test3
    su - test -c "touch /home/test/testfile1"
    su - test -c "touch /home/test/testfile2"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    su - test -c "setfacl -m u:test1:r,u:test2:w,u:test3:x testfile1"   
    CHECK_RESULT $? 0 0 "set testfile1 acl fail"
    su - test -c "getfacl testfile1" | grep "user:test1:r--"
    CHECK_RESULT $? 0 0 "get testfile1 acl for test1 fail"
    su - test -c "getfacl testfile1" | grep "user:test2:-w-"
    CHECK_RESULT $? 0 0 "get testfile1 acl for test2 fail"
    su - test -c "getfacl testfile1" | grep "user:test3:--x"
    CHECK_RESULT $? 0 0 "get testfile1 acl for test3 fail"

    su - test -c "chmod 744 testfile2"
    CHECK_RESULT $? 0 0 "set testfile2 acl fail"
    stat -c %a /home/test/testfile1 | grep 674
    CHECK_RESULT $? 0 0 "testfile1 acl error"
    stat -c %a /home/test/testfile2 | grep 744
    CHECK_RESULT $? 0 0 "testfile2 acl error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    userdel -rf test1
    userdel -rf test2
    userdel -rf test3
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
