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
#@Date      	:   2024-2-21
#@License   	:   Mulan PSL v2
#@Desc      	:   Test sudo
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  if [ ! -d ./tmp_test/lib ]; then
    LOG_ERROR "Please compile it first!"
    exit 1
  fi
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  pushd ./tmp_test/lib || exit 1
  total=0
  success=0
  skip=0
  failed=0
  LD_LIBRARY_PATH=""
  for dir_name in *
  do
    if [[ ! -d "${dir_name}" || "${dir_name}" == "zlib" ]]; then
        continue
    fi
    LD_LIBRARY_PATH="$(pwd)/${dir_name}/.libs:${LD_LIBRARY_PATH}"
  done
  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
  for dir_name in *
  do
    if [[ ! -d "${dir_name}" || "${dir_name}" == "zlib" ]]; then
        continue
    fi
    LOG_INFO "Start to exec ${dir_name} dir test"
    pushd "./${dir_name}/.libs" || continue
    while read -r test_file; do
      if [ -z "${test_file}" ];then
        continue
      fi
      # special
      if [ "${test_file}" == "conf_test" ];then
        ((skip++))
        continue
      elif [ "${test_file}" == "check_iolog_path" ];then
        ./"${test_file}" ../regress/iolog_path/data
      elif [ "${test_file}" == "store_sudo_test" ];then
        ./"${test_file}" ../regress/eventlog_store/*.json.in
      elif [ "${test_file}" == "store_json_test" ];then
        ./"${test_file}" ../regress/eventlog_store/*.json.in
      elif [ "${test_file}" == "check_parse_json" ];then
        ./"${test_file}" ../regress/parse_json/*.in
      elif [ "${test_file}" == "check_wrap" ];then
        ./"${test_file}" ../regress/logwrap/check_wrap.in
      elif [ "${test_file}" == "check_iolog_json" ];then
        ./"${test_file}" ../regress/iolog_json/*.in
      else
        ./"${test_file}"
      fi

      ret_code=$?
      expect_code=0
      if [ ${ret_code} -eq ${expect_code} ]; then
        ((success++))
      else
        LOG_ERROR "exec ${test_file} failed"
        ((failed++))
      fi
      ((total++))
    done < ../test_list
    popd || continue
  done
  CHECK_RESULT "${failed}" 0 0 "sudo test failed ${failed}!!!"
  LOG_INFO "exec ${total}, success ${success}, skip ${skip}, failed ${failed}, pass rate $(echo "${success}" "${failed}" | awk '{printf "%.2f", $1/($1 + $2) * 100 }')%"
  popd || exit
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf ./tmp_test
  LOG_INFO "End to restore the test environment."
}

main "$@"
