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
#@Date      	:   2024-1-16
#@License   	:   Mulan PSL v2
#@Desc      	:   Test python3
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  pushd ./tmp_test || exit 1
  if [ ! -d ./Lib ]; then
    LOG_ERROR "Please compile first!!!"
    exit 1
  fi
  popd || return
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/ || exit 1
  LOG_INFO "Start exec python3 test."
  PYTHONPATH="$(pwd)/build/lib.linux-*:$(pwd)/Lib" ./python -m unittest discover ./Lib/unittest/test
  CHECK_RESULT $? 0 0 "exec python3 test failed!!!"
  popd || return
  LOG_INFO "End to run test."
}


function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
