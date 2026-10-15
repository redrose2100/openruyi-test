#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   jingxiaohui
# @Contact   :   jingxiaohui@uniontech.com
# @Date      :   2024.6.21
# @License   :   Mulan PSL v2
# @Desc      :   cd-L ;cd -P cd -e using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "cd --help"|grep cd
  CHECK_RESULT $? 0 0 "cd --help fail"
  utshell -c "mkdir /home/niu"
  CHECK_RESULT $? 0 0 "mkdir /home/niu fail"
  utshell -c "ln -s /home/niu/ /etc"
  CHECK_RESULT $? 0 0 "ln -s /home/niu/ /etc fail"
  utshell -c "cd -L /etc/niu;pwd"|grep "/etc/niu"
  CHECK_RESULT $? 0 0 "pwd fail"
  utshell -c "cd -P /etc/niu/;pwd"|grep "/home/niu"
  CHECK_RESULT $? 0 0 "pwd fail"
  utshell -c "mkdir /home/uos"
  CHECK_RESULT $? 0 0 "mkdir /home/uos fail"
  utshell -c "cd -e /home/uos;echo \$?"|grep 0
  CHECK_RESULT $? 0 0 "echo \$? fail"
  utshell -c "cd -e /home/uos;pwd"|grep /home/uos
  CHECK_RESULT $? 0 0 "pwd fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rmdir /home/niu
  rmdir /home/uos
  rm -rf /etc/niu
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"