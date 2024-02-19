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
#@Date      	:   2024-2-6
#@License   	:   Mulan PSL v2
#@Desc      	:   Test asio
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  if [ ! -f ./tmp_test/tests/success_list ]; then
    LOG_ERROR "Please compile it first!"
    exit 1
  fi
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/tests || exit 1

  LOG_INFO "Start exec asio test"

  total=0
  success=0
  failed=0
  while read -r line || [[ -n "${line}" ]]; do
    if ./"${line}" | tee "${line}".log;then
          ((success++))
    else
       LOG_ERROR "${line} exec failed!"
          ((failed++))
    fi
    ((total++))
  done < ./success_list
  LOG_INFO "exec ${total}, success ${success},failed ${failed}, pass rate $(echo "${success}" "${failed}" | awk '{printf "%.2f", $1/($1 + $2) * 100 }')%"
  CHECK_RESULT "${failed}" 0 0 "libcgroup gtest failed!!!"
  popd || return
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
