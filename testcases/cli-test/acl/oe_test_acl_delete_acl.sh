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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/07.19
# @License   :   Mulan PSL v2
# @Desc      :   Delete ACL function test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  useradd test1
  echo test1:deepin12#$ | chpasswd
  mkdir testdir
  chacl -b u::rw,g::rx,o::-,u:test1:rw,g:test1:rw,m::rwx u::rwx,g::r,o::-,u:test1:r,m::rwx testdir
  mkdir testdir/subtestdir
  touch testdir/subtestfile
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  setfacl -x mask testdir
  CHECK_RESULT $? 0 1 "ACL_MASK deleted successfully"
  setfacl -x test1 testdir/
  getfacl testdir | grep 'user::rw-'
  CHECK_RESULT $? 0 0 "ACL_ USER deletion failed"
  setfacl -x g:test1 testdir
  getfacl testdir | grep 'group::r-x'
  CHECK_RESULT $? 0 0 "ACL_GROUP deletion failed"
  setfacl -x mask testdir
  getfacl testdir | grep 'mask::r-x'
  CHECK_RESULT $? 0 1 "ACL_MASK deleted failed"
  setfacl -k testdir
  getfacl testdir | grep 'default'
  CHECK_RESULT $? 0 1 "ACL_ALL deleted failed"
  setfacl -R -b testdir
  getfacl testdir/* | grep 'default'
  CHECK_RESULT $? 0 1 "ACL_ALL Recursive deletion failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf testdir
  userdel -rf test1
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
