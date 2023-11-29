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
# @Date      :   2023-11-29
# @License   :   Mulan PSL v2
# @Desc      :   default acl inherit fun02
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
    setfacl -d -m u::rwx,g::rwx,o::rwx,u:test2:rwx,g:test1:rwx testdir
    CHECK_RESULT $? 0 0 "set testdir default acl fail" 
    mkdir testdir/subtestdir1
    CHECK_RESULT $? 0 0 "mkdir subtestdir1 fail" 
    touch testdir/subtestfile1
    CHECK_RESULT $? 0 0 "touch subtestfile1 fail" 
    echo '# file: testdir/subtestdir1
# owner: root
# group: root
user::rwx
user:test2:rwx
group::rwx
group:test1:rwx
mask::rwx
other::rwx
default:user::rwx
default:user:test2:rwx
default:group::rwx
default:group:test1:rwx
default:mask::rwx
default:other::rwx
' >subtestdir1-01.txt
    getfacl testdir/subtestdir1 > subtestdir1.txt
    diff subtestdir1-01.txt subtestdir1.txt -w
    CHECK_RESULT $? 0 0 "subtestdir1 acl error" 

    echo '# file: testdir/subtestfile1
# owner: root
# group: root
user::rw-
user:test2:rwx                  #effective:rw-
group::rwx                      #effective:rw-
group:test1:rwx                 #effective:rw-
mask::rw-
other::rw-
' >subtestfile1-01.txt
    getfacl testdir/subtestfile1 > subtestfile1.txt
    diff subtestfile1-01.txt subtestfile1.txt -w
    CHECK_RESULT $? 0 0 "subtestfile1 acl error" 
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
