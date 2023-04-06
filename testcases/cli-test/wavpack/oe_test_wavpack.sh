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
# @Author    :   changxuqing
# @Contact   :   changxuqing@uniontech.com
# @Date      :   2023/04/06
# @License   :   Mulan PSL v2
# @Desc      :   test wavpack
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "wavpack"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  wavpack  test.wav -o test 2>&1 | grep -i "created test.wv"
  CHECK_RESULT $? 0 0 "step1 fail"
  test -e test.wv
  CHECK_RESULT $? 0 0 "test.wn not exist"
  wavpack  test.wv -o  2.dff 2>&1 | grep -i "created 2.dff"
  CHECK_RESULT $? 0 0 "step2 fail"
  test -e 2.dff
  CHECK_RESULT $? 0 0 "2.dff not exist"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf  test.wv 2.dff
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
