#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2024-2-28
#@License   	:   Mulan PSL v2
#@Desc      	:   Test gawk
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  if [ ! -f ./tmp_test/test/all_test.txt ]; then
    LOG_ERROR "Please compile it first!"
    exit 1
  fi
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/test || exit 1

  LOG_INFO "Start exec gawk test"

  total=0
  success=0
  failed=0
  skip=0
  cat all_test.txt > exec_test.txt
  while read -r ignore_test; do
    if [ -z "${ignore_test}" ];then
      continue
    fi

    if grep "${ignore_test}" exec_test.txt &>/dev/null;then
      grep -v "${ignore_test}" exec_test.txt > tmp.log
      cat tmp.log > exec_test.txt
      LOG_WARN "skip ${ignore_test}"
      ((skip++))
    fi
    ((total++))
  done < ../../ignore.txt

  while read -r test_file; do
    if [ -z "${test_file}" ];then
      continue
    fi
    sh ./"${test_file}.test"
    if [ -f "./_${test_file}" ];then
      LOG_ERROR "${test_file} exec failed!"
      ((failed++))
    else
      ((success++))
    fi
    ((total++))
  done < ./exec_test.txt
  LOG_INFO "exec ${total}, success ${success},skip ${skip}, failed ${failed}, pass rate $(echo "${success}" "${failed}" | awk '{printf "%.2f", $1/($1 + $2) * 100 }')%"
  CHECK_RESULT "${failed}" 0 0 "gawk test failed!!!"
  popd || return
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
