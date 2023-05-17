#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2023/04/11
# @License   :   Mulan PSL v2
# @Desc      :   test flac
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "yaji yaji-devel"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  gcc test.c -o test -lyajl
  test -e test
  CHECK_RESULT $? 0 0 "test not exist"
  ./test 2>&1 | grep -i '{"name":"Alice","age":30}'
  CHECK_RESULT $? 0 0 "yaji failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf test
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
