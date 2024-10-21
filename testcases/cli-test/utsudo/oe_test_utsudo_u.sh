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
  useradd admin1
  useradd admin2
  echo "admin1:deepin12#$" | chpasswd
  echo "admin2:deepin12#$" | chpasswd
  sed -i '/^root/a\admin1    ALL=(ALL) ALL' /etc/sudoers
  sed -i '/^root/a\admin2    ALL=(ALL) ALL' /etc/sudoers
  sed -i '/^root/a\admin1    ALL=(ALL) ALL' /etc/utsudoers
  sed -i '/^root/a\admin2    ALL=(ALL) ALL' /etc/utsudoers
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  echo "deepin12#$" | su -c "echo qwert > /home/admin1/test.txt" admin1
  CHECK_RESULT $? 0 0 "echo qwert > /home/admin1/test.txt admin1 fail"
  echo "deepin12#$" | su -c "ls -l /home/admin1/test.txt" admin1 |grep -E "uos|uos|rw-r--r--"
  CHECK_RESULT $? 0 0 "su -c 'ls -l /home/admin1/test.txt' admin1 fail"

  echo "deepin12#$" | su -c "chmod 660 /home/admin1/test.txt" admin1
  echo "deepin12#$" | su -c "ls -l /home/admin1/test.txt" admin1 |grep "rw-rw----"
  CHECK_RESULT $? 0 0 "su -c 'ls -l /home/admin1/test.txt' 660 admin1 fail"

  echo "deepin12#$" |su -c "echo 'deepin12#$' | utsudo -S -u admin2 cat /home/admin1/test.txt" admin1
  CHECK_RESULT $? 1 0 "utsudo -S -u admin2 cat /home/admin1/test.txt fail"

  echo "deepin12#$" |su -c "echo 'deepin12#$' | utsudo -S chown admin2 /home/admin1/test.txt" admin1
  echo "deepin12#$" | su -c "ls -l /home/admin1/test.txt" admin1 |grep "admin2"
  CHECK_RESULT $? 0 0 "utsudo chown admin2 /home/admin1/test.txt fail"

  echo "deepin12#$" |su -c "echo 'deepin12#$' | utsudo -S -u admin1 cat /home/admin1/test.txt" admin1
  CHECK_RESULT $? 0 0 "utsudo -u admin1 cat /home/admin1/test.txt fail"


  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  userdel admin1
  userdel admin2
  rm -rf /home/admin*
  sed -i '/^admin1/d' /etc/sudoers
  sed -i '/^admin1/d' /etc/utsudoers
  sed -i '/^admin2/d' /etc/sudoers
  sed -i '/^admin2/d' /etc/utsudoers
  LOG_INFO "Finish environment cleanup!"
}

main "$@"