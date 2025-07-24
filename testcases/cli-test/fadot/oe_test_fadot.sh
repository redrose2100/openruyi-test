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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2024/08/21
# @License   :   Mulan PSL v2
# @Desc      :   test fadot
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL augeas
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  fadot -o show "a(b|c)" |grep "a"
  CHECK_RESULT $? 0 0 "Error reporting detailed information of regular expression"
  fadot -o concat "ab" "cd" |grep "b"
  CHECK_RESULT $? 0 0 "Connecting two regular expressions yields an error"
  fadot -o union "ab" "cd" |grep "d"
  CHECK_RESULT $? 0 0 "Generate union error for two regular expressions"
  fadot -o json "a(b|c)"  |grep "b-c"
  CHECK_RESULT $? 0 0 "Output regular expression information in JSON format with error message"
  fadot -o example "[0-9]" | grep -q -E "[0-9]"
  CHECK_RESULT $? 0 0 "Example generation failed"
  fadot -n -o show "a{2,3}" | grep -q "aa(a|())"
  CHECK_RESULT $? 0 0 "Non-minimized expansion failed"
  fadot -f /tmp/regex_test.dot -o show "a(b|c)" && grep -q "digraph" /tmp/regex_test.dot
  CHECK_RESULT $? 0 0 "DOT file generation failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf /tmp/regex_test.dot
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
