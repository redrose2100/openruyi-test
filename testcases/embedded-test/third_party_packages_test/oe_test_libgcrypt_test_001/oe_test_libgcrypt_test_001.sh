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
#@Date      	:   2023-12-27
#@License   	:   Mulan PSL v2
#@Desc      	:   Test libgcrypt
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  pushd ./tmp_test/tests || exit 1
  if [ "$(find . -maxdepth 1 -type f -executable | grep -v '.in' | grep -vc '.sh')" -eq 0 ]; then
    LOG_ERROR "Please compile it first!"
    exit 1
  fi
  popd || exit
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/tests || exit 1
  total=0
  success=0
  failed=0
  skip=0
  export GCRYPT_IN_REGRESSION_TEST=1
  while read -r exec_file || [[ -n "${exec_file}" ]]; do
    LOG_INFO "Start to exec ${exec_file}"
    ./"${exec_file}"
    ret_code=$?
    expect_code=0

    if [ ${ret_code} -eq ${expect_code} ]; then
      ((success++))
    elif [ ${ret_code} -eq 77 ]; then
      ((skip++))
    else
      LOG_ERROR "exec ${exec_file} failed"
      ((failed++))
    fi
    ((total++))
  done <test_program
  CHECK_RESULT "${failed}" 0 0 "grep test failed ${failed}!!!"
  LOG_INFO "exec ${total}, success ${success}, skip ${skip},failed ${failed}, pass rate $(echo "${success}" "${failed}" | awk '{printf "%.2f", $1/($1 + $2) * 100 }')%"
  popd  || exit
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
