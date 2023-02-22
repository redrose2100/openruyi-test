#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libguestfs command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL libguestfs
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  guestfish -h | grep '命令'
  CHECK_RESULT $? 0 0 "Check guestfish -h failed"

  guestfish -h cat | grep 'cat'
  CHECK_RESULT $? 0 0 "Check guestfish -h cat failed"

  guestfish --csh -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --csh failed"

  guestfish -c test:///default -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish -c failed"

  guestfish -d vm3_3 -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish -d failed"

  guestfish --echo-keys -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --echo-keys failed"

  echo "--help" >file.txt
  guestfish -f file.txt -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish -f failed"

  guestfish --format=qcow2 -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --format failed"

  guestfish --help 2>&1 | grep 'guest filesystem shell'
  CHECK_RESULT $? 0 0 "Check guestfish --help failed"

  guestfish --key ID:key:KEY_STRING -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --key failed"

  guestfish --keys-from-stdin -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --keys-from-stdin failed"

  guestfish --listen
  CHECK_RESULT $? 0 0 "Check guestfish --listen failed"

  guestfish -N fs:ext4
  CHECK_RESULT $? 0 0 "Check guestfish -N failed"

  guestfish -n -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish -n failed"

  guestfish --no-dest-paths -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --no-dest-paths failed"

  guestfish --pipe-error -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --pipe-error failed"

  guestfish --progress-bars -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --progress-bars failed"

  guestfish --no-progress-bars -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --no-progress-bars failed"

  guestfish --selinux -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --selinux failed"

  guestfish --ro -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --ro failed"

  guestfish -v -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish -v failed"

  guestfish -V 2>&1 | grep $(rpm -q libguestfs --queryformat '%{version}\n')
  CHECK_RESULT $? 0 0 "Check guestfish -V failed"

  guestfish --rw -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish --rw failed"

  guestfish -x -a vm3_3.img -i cat /etc/group
  CHECK_RESULT $? 0 0 "Check guestfish -x failed"

  guestfish -h 2>&1 | grep 'help'
  CHECK_RESULT $? 0 0 "Check guestfish -h failed"

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf file*
  DNF_INSTALL
  LOG_INFO "Finish to restore the test environment."
}

main $@
