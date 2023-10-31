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
# @Date      :   2023-10-31
# @License   :   Mulan PSL v2
# @Desc      :   default acl inherit
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    useradd test1
    useradd test2
    mkdir testdir
    setfacl -m g:test1:rw testdir
    setfacl -d -m u::rw,g::rx,o::-,u:test2:rw,g:test1:r,m::rw testdir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    mkdir testdir/subtestdir
    CHECK_RESULT $? 0 0 "mkdir subtestdir fail" 
    touch testdir/subtestfile
    CHECK_RESULT $? 0 0 "touch subtestfile fail" 
    setfacl -d -m u::rwx,g::rwx,o::rwx,u:test2:rwx,g:test1:rwx testdir
    CHECK_RESULT $? 0 0 "set testdir acl fail" 

    echo '# file: testdir/subtestdir
# owner: root
# group: root
user::rw-
user:test2:rw-
group::r-x      #effective:r--
group:test1:r--
mask::rw-
other::---
default:user::rw-
default:user:test2:rw-
default:group::r-x      #effective:r--
default:group:test1:r--
default:mask::rw-
default:other::---
' >subtestdir01.txt
    getfacl testdir/subtestdir > subtestdir.txt
    diff subtestdir01.txt subtestdir.txt -w
    CHECK_RESULT $? 0 0 "subtestdir acl error" 

    echo '# file: testdir/subtestfile
# owner: root
# group: root
user::rw-
user:test2:rw-
group::r-x                      #effective:r--
group:test1:r--
mask::rw-
other::---
' >subtestfile01.txt
    getfacl testdir/subtestfile > subtestfile.txt
    diff subtestfile01.txt subtestfile.txt -w
    CHECK_RESULT $? 0 0 "subtestfile acl error" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test1
    userdel -rf test2
    rm -rf testdir subtestfile* subtestdir*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
