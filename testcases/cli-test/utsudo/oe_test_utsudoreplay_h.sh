#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2025/01/13
# @License   :   Mulan PSL v2
# @Desc      :   using the utsudoreplay -h command
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
  echo "utsudoreplay -h"
  CHECK_RESULT $? 0 0 "su -c 'utsudoreplay -h' fail"
  echo "utsudoreplay -V"
  CHECK_RESULT $? 0 0 "su -c 'utsudoreplay -V' fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  userdel -rf uos
  userdel -rf user
  sed -i '/^uos/d' /etc/sudoers
  sed -i '/^uos/d' /etc/utsudoers
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
