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
#@Date      	:   2024-1-10
#@License   	:   Mulan PSL v2
#@Desc      	:   Test libcgroup
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  if [ ! -f ./tmp_test/gunit/.libs/gtest ]; then
    LOG_ERROR "Please compile it first!"
    exit 1
  fi
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test || exit 1
  currrent_dir=$(pwd)
  export LD_LIBRARY_PATH="${currrent_dir}":$LD_LIBRARY_PATH
  cd gunit || exit 1
  LOG_INFO "Start exec gtest"
  .libs/gtest | tee gtest.log
  # check result
  failed_line_num=$(cat -n gtest.log | grep 'listed below:' | tail -n 1 | awk '{print $1}')
  if [ -n "${failed_line_num}" ]; then
    last_line_num=$(cat -n gtest.log | tail -n 1 | awk '{print $1}')
    sed -n "${failed_line_num},${last_line_num}p" gtest.log | grep -v 'listed below:' | grep -v 'FAILED TESTS' | grep -v '^$' >failed.log
    while read -r line || [[ -n "${line}" ]]; do
      grep -v "${line}" failed.log >tmp.log
      cat tmp.log >failed.log
    done <../../ignore.txt

    failed_num=$(wc -l < failed.log)
    CHECK_RESULT "${failed_num}" 0 0 "libcgroup gtest failed!!!"
  fi
  popd || return
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
