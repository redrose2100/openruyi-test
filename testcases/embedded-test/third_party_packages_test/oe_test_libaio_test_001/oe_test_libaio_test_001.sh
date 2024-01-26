#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   hukun
#@Contact   	:   hu_kun@hoperun.com
#@Date      	:   2024-1-3
#@License   	:   Mulan PSL v2
#@Desc      	:   Test libaio
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test || exit 1
  # step 1 general read/write test cases
  LOG_INFO "Start exec step 1"
  mkdir testdir
  echo "test" >testdir/rofile
  chmod 400 testdir/rofile
  echo "test" >testdir/rwfile
  chmod 600 testdir/rwfile
  echo "test" >testdir/wofile
  chmod 200 testdir/wofile
  mkdir /testdir
  echo "test" >/testdir/rwfile
  chmod 600 /testdir/rwfile
  ./runtests.sh cases/2.p cases/3.p cases/4.p cases/5.p cases/6.p cases/7.p cases/11.p \
    cases/12.p cases/13.p cases/14.p cases/15.p cases/16.p cases/17.p cases/18.p cases/19.p cases/20.p cases/21.p cases/22.p cases/23.p
  CHECK_RESULT $? 0 0 "libaio test step 1 failed!!!"
  # step 2 enospc test
  LOG_INFO "Start exec step 2"
  mkdir testdir.ext2 testdir.enospc
  dd if=/dev/zero bs=1M count=10 of=ext2.img
  mke2fs -F -b 4096 ext2.img
  mount -o loop -t ext2 ext2-enospc.img testdir.enospc
  ./runtests.sh cases/10.p
  CHECK_RESULT $? 0 0 "libaio test step 2 failed!!!"
  umount testdir.enospc
  # step 3 ext2 test
  LOG_INFO "Start exec step 3"
  mount -o loop -t ext2 ext2.img testdir.ext2
  ./runtests.sh cases/8.p
  CHECK_RESULT $? 0 0 "libaio test step 3 failed!!!"
  umount testdir.ext2
  popd || return
  LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test /testdir
  LOG_INFO "End to restore the test environment."
}

main "$@"
