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
# @Date      :   2024/08/21
# @License   :   Mulan PSL v2
# @Desc      :   using the utsudo -S command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utsudo"
  useradd admin3
  echo "admin3:deepin12#$" | chpasswd
  sed -i '/^root/a\admin3    ALL=(ALL) ALL' /etc/sudoers
  sed -i '/^root/a\admin3    ALL=(ALL) ALL' /etc/utsudoers
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  echo "deepin12#$" | su -c "cat > /home/admin3/test.sh <<-EOF
echo \\\$var
EOF
var=aaa;export var;utsudo -S sh /home/admin3/test.sh" admin3 |grep aaa

  CHECK_RESULT $? 1 0 "utsudo sh /home/admin3/test.sh fail"

  echo "deepin12#$" | su -c "cat > /home/admin3/test.sh <<-EOF
echo \\\$var
EOF
var=aaa;export var;utsudo -S -E sh /home/admin3/test.sh" admin3 |grep aaa
  CHECK_RESULT $? 0 0 "utsudo -E sh /home/admin3/test.sh fail"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  userdel admin3
  rm -rf /home/admin3/test.sh /home/admin3
  sed -i '/^admin3/d' /etc/sudoers
  sed -i '/^admin3/d' /etc/utsudoers
  LOG_INFO "Finish environment cleanup!"
}

main "$@"