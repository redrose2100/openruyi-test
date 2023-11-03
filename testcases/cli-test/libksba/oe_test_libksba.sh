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
# @Date      :   2023/07.21
# @License   :   Mulan PSL v2
# @Desc      :   libksba function test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL "libksba gnupg2 gnupg2-smime"
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  ldd -v /usr/bin/gpgsm | grep libksba
  CHECK_RESULT $? 0 0 "The libksba.so.8 link in the /usr/bin/gpgsm directory does not exist"
  ldd -v /usr/bin/kbxutil | grep libksba
  CHECK_RESULT $? 0 0 "The libksba.so.8 link in the /usr/bin/kbxutil directory does not exist"
  openssl req -new -x509 -days 3650 -keyout CARoot.key -out CARoot.crt -nodes -subj "/CN=china/L=wuhan/O=uniontech/CN=www.chinauos.com/"
  CHECK_RESULT $? 0 0 "Failed to generate private key file and public key certificate using 509 certificate"
  test -f CARoot.crt && test -f CARoot.key
  CHECK_RESULT $? 0 0 "The private key file or public key certificate does not exist"
  gpgsm --help 2>&1 | grep verbose
  CHECK_RESULT $? 0 0 "Gpgsm failed to view help"
  kbxutil --help 2>&1 | grep verbose
  CHECK_RESULT $? 0 0 "Kbxutil failed to view help"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  DNF_REMOVE "$@"
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
