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
#@Date      	:   2024-1-4
#@License   	:   Mulan PSL v2
#@Desc      	:   Test libcap-ng
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  pushd ./tmp_test/test || exit 1
  if [[ ! -f ./lib_test || ! -f ./thread_test ]]; then
    LOG_ERROR "Please compile first!!!"
    exit 1
  fi
  popd || return
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/test || exit 1
  LOG_INFO "Start exec lib_test"
  .libs/lib_test
  CHECK_RESULT $? 0 0 "lib_test failed!!!"
  LOG_INFO "Start exec thread_test"
  .libs/thread_test
  CHECK_RESULT $? 0 0 "thread_test failed!!!"
  popd || return
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
