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
# shellcheck disable=SC1091
source ../comm_lib.sh

function config_params() {
    if ! dd if=/dev/zero of=/tmp/.libaio_odirect_test bs=4k count=1 oflag=direct 2>/dev/null; then
        LOG_INFO "Skip: O_DIRECT not supported (no block device, likely tmpfs/initrd rootfs)"
        exit 255
    fi
    rm -f /tmp/.libaio_odirect_test
}

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
  for case_num in 2 3 4 5 6 7 11 12 13 14 15 16 17 18 19 20 21 22
  do
    ./runtests.sh "cases/${case_num}.p "| tee "${case_num}.log"
  done
  # step 2 enospc test
  LOG_INFO "Start exec step 2"
  mkdir testdir.ext2 testdir.enospc
  dd if=/dev/zero bs=1M count=10 of=ext2.img
  mke2fs -F -b 4096 ext2.img
  mount -o loop -t ext2 ext2-enospc.img testdir.enospc
  ./runtests.sh cases/10.p | tee "10.log"
  umount testdir.enospc
  # step 3 ext2 test
  LOG_INFO "Start exec step 3"
  mount -o loop -t ext2 ext2.img testdir.ext2
  ./runtests.sh cases/8.p | tee "8.log"

  umount testdir.ext2
  # result check
  shopt -s nullglob
  logs=(*.log)
  printf '%s\n' "${logs[@]}" > logs_file.txt
  while read -r line; do
    if [ -z "${line}" ];then
      continue
    fi
    grep -v "${line}.log" logs_file.txt >tmp.log
    cat tmp.log > logs_file.txt
  done <../ignore.txt

  while read -r log_file; do
    if [ -z "${log_file}" ];then
      continue
    fi
    failed_num=$(grep "Pass:" "${log_file}"|awk '{print $NF}')
    CHECK_RESULT "${failed_num}" 0 0 "libaio cases/${log_file%%.log}.p test failed!!!"
  done <./logs_file.txt
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
