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
#@Desc      	:   Test grep
#####################################

# shellcheck disable=SC2016,SC1091,SC2035

source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  pushd ./tmp_test/tests || exit 1
  if [ "$(find . -maxdepth 1 -type f -executable | wc -l)" -eq 0 ]; then
    LOG_ERROR "Please compile it first!"
    exit 1
  fi
  sed -i 's#. "${srcdir=.}/init.sh".*#. "${srcdir=.}/init.sh";path_prepend_ ${srcdir}#g' *
  popd || return
  LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/tests || exit 1
  total=0
  success=0
  failed=0
  skip=0
  current_path="$(pwd)"
  export srcdir="${current_path}"
  export AWK=awk
  abs_top_srcdir="$(
    cd ..
    pwd
  )"
  export abs_top_srcdir="${abs_top_srcdir}"
  export abs_srcdir="${current_path}"
  export built_programs='grep egrep fgrep'
  grep_version=$(env grep --version | sed -n '1s/.* //p;q')
  export VERSION="${grep_version}"
  for exec_file in $(find . -maxdepth 1 -type f -executable | grep -v '.pl' | grep -v get-mb-cur-max | grep -v hash-collision-perf); do
    LOG_INFO "Start to exec ${exec_file}"
    bash "${exec_file}" &>"${exec_file}.log"
    ret_code=$?
    # Special handling of the ./triple-backref ./equiv-classes use case results in a failure
    if [[ "${exec_file}" == "./triple-backref" || "${exec_file}" == "./equiv-classes" ]]; then
      expect_code=1
    else
      expect_code=0
    fi
    if [ ${ret_code} -eq ${expect_code} ]; then
      ((success++))
    elif [ ${ret_code} -eq 77 ]; then
      ((skip++))
    else
      LOG_ERROR "exec ${exec_file} failed"
      ((failed++))
    fi
    ((total++))
  done
  CHECK_RESULT "${failed}" 0 0 "grep test failed ${failed}!!!"
  LOG_INFO "exec ${total}, success ${success}, skip ${skip},failed ${failed}, pass rate $(echo "${success}" "${failed}" | awk '{printf "%.2f", $1/($1 + $2) * 100 }')%"
  popd || return
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
