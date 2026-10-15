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
# @Author    :   mataotao
# @Contact   :   mataotao@uniontech.com
# @Date      :   2024/08/15
# @License   :   Mulan PSL v2
# @Desc      :   using the utsudo -S command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utsudo"
  useradd uos
  echo "uos:deepin12#$" | chpasswd
  sed -i '/^root/a\uos    ALL=(ALL) ALL' /etc/sudoers
  sed -i '/^root/a\uos    ALL=(ALL) ALL' /etc/utsudoers
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utsudo -K;echo "deepin12#$" | su -c "utsudo -S useradd user" uos
  CHECK_RESULT $? 0 0 "su -c 'utsudo -S useradd user' uos fail"
  id user
  CHECK_RESULT $? 0 0 "su -c id user fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  userdel uos
  userdel user
  sed -i '/^uos/d' /etc/sudoers
  sed -i '/^uos/d' /etc/utsudoers
  LOG_INFO "Finish environment cleanup!"
}

main "$@"