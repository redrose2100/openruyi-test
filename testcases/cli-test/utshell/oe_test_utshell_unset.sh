#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   mataotao
# @Contact   :   mataotao@uniontech.com
# @Date      :   2024/06/03
# @License   :   Mulan PSL v2
# @Desc      :   utshell-test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  export LANG=en_US.UTF-8
  utshell -c "unset --help" |grep Options
  CHECK_RESULT $? 0 0 "unset --help fail"
  utshell -c "function show_result(){ echo 'Last Command Return: $?'; };show_result" | grep "Last Command Return"
  CHECK_RESULT $? 0 0 "function command fail"
  utshell -c "function show_result(){ echo 'Last Command Return: $?'; };show_result;unset -f show_result;show_result" | grep "command not found"
  CHECK_RESULT $? 1 0 "unset -f command fail"
  utshell -c "declare a=3;declare -n b=a;declare -p b" | grep "declare -n b=\"a\""
  CHECK_RESULT $? 0 0 "declare -n command fail"
  utshell -c "declare a=3;declare -n b=a;declare -p b;unset -n b;declare -p b"
  CHECK_RESULT $? 1 0 "unset -n command fail"
  utshell -c "declare a=3;declare -n b=a;declare -p b;unset -n b;declare -p a" | grep "declare -- a=\"3\""
  CHECK_RESULT $? 0 0 "unset -n command fail"
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf hello.sh
  LOG_INFO "Finish environment cleanup!"
}

main "$@"