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
# shellcheck disable=SC1091,SC2181
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
  declare -A ignoreFail
  getCasesFromFile ignoreFail ignore.txt

  pushd ./tmp_test/test || exit 1
  LOG_INFO "Start exec gawk test"

  total=0
  success=0
  failed=0
  skip=0
  cat all_test.txt >exec_test.txt

  if [ ! -e /usr/lib64/locale/ ]; then
    del_list=(backbigs1 backsmalls1 commas mbfw1 mbprintf1 mbprintf4 mbprintf5 mbstr1 mbstr2)
    for one in "${del_list[@]}"; do
      sed -i "/${one}/d" exec_test.txt
    done
  fi

  list=(mbstr1 mpfrcase2 mpfrcase mpfrfield mpfrieee mpfrmemok1 mpfrnegzero2 mpfrnegzero mpfrnonum mpfrrem mpfrsort mpfrstrtonum mpgforcenum)
  for item in "${list[@]}"; do sed -i 's/2>&1//g' "$item".test; done
  sed -i '/gawk:/d' mbstr1.ok mbstr2.ok

  while read -r test_file; do
    ((total++))
    if [ -z "${test_file}" ]; then
      continue
    fi
    [[ ${ignoreFail[$test_file]} -eq 1 ]] && ((++skip)) && continue
    sh ./"${test_file}.test"
    if [[ $? -eq 1 ]]; then
      LOG_ERROR "${test_file} exec failed!"
      ((failed++))
    else
      ((success++))
    fi
  done <./exec_test.txt
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
