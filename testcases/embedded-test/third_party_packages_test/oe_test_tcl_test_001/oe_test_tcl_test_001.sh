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
#@Date      	:   2023-12-14
#@License   	:   Mulan PSL v2
#@Desc      	:   Test tcl
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  tcl_version=$(cat ./tmp_test/VERSION)
  lib_tcl_so=$(find /usr -name libtcl"${tcl_version}".so | sort | head -n 1)
  if [ -n "${lib_tcl_so}" ]; then
    return
  else
    lib_tcl_so_num=$(find /usr -name "libtcl${tcl_version}.so.*" | sort | head -n 1)
    if [ -n "${lib_tcl_so}" ]; then
      ln -s "${lib_tcl_so_num}" "$(dirname "${lib_tcl_so_num}")/libtcl${tcl_version}.so"
    else
      LOG_ERROR "libtcl${tcl_version}.so must be provided"
    fi
  fi
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test || exit 1
  current_path="$(pwd)"
  export TCL_LIBRARY="${current_path}"/library
  ./tcltest tests/all.tcl | tee tmp.log
  grep 'Files with failing tests:' tmp.log | awk -F ': ' '{print $2}' | sed 's/ /\n/' >failed.log
  while read -r line || [[ -n "${line}" ]]; do
    grep -v "${line}" failed.log >tmp.log
    cat tmp.log >failed.log
  done <../ignore.txt
  failed_num=$(grep -vc '^$' failed.log)
  CHECK_RESULT "${failed_num}" 0 0 "exec ./tcltest tests/all.tcl failed ${failed_num}"
  popd || return
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
