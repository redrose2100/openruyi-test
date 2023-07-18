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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/07/17
# @License   :   Mulan PSL v2
# @Desc      :   sm3 Encryption test
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  useradd testsm3
  echo "testsme!@#" | passwd --stdin testsm3
  cp /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  grep "testsm3:\$6" /etc/shadow
  CHECK_RESULT $? 0 0 "Default encryption is not sha512"
  sed -i 's/password    sufficient    pam_unix.so .*/password    sufficient    pam_unix.so sm3 shadow nullok try_first_pass use_authtok/g' /etc/pam.d/system-auth
  CHECK_RESULT $? 0 0 "Description Failed to modify the configuration file"
  echo "testsme#@!" | passwd --stdin testsm3
  CHECK_RESULT $? 0 0 "Password change failed"
  grep "testsm3:\$sm3" /etc/shadow
  CHECK_RESULT $? 0 0 "sm3 encryption fails"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  userdel -rf testsm3
  mv /etc/pam.d/system-auth_bak /etc/pam.d/system-auth -f
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
