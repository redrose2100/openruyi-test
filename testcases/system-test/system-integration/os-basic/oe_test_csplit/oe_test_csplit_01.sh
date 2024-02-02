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
# @Author    :   liliqi
# @Contact   :   liliqi@uniontech.com
# @Date      :   2024/02/02
# @License   :   Mulan PSL v2
# @Desc      :   csplit case
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  mkdir -p /tmp/llq
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > /tmp/test.txt << EOF
This is a test file.
It contains some lines of text that can be used for testing the csplit command.
This line can be used as a separator.
Here is some more text that can be used for testing purposes.
Another separator line.
The end.
EOF

   
    csplit -k "/tmp/test.txt" 1 -k -f "/tmp/llq/test1_"
    test -f "/tmp/llq/test1_00" && test -f  "/tmp/llq/test1_01"
    CHECK_RESULT $? 0  0 "The return value is not 2"
    csplit -k "/tmp/test.txt" '/separator/' "{*}" -f "/tmp/llq/test2_"
    test -f "/tmp/llq/test2_00" && test -f  "/tmp/llq/test2_01" && test -f  "/tmp/llq/test2_02"
    CHECK_RESULT $? 0 0 "The return value is not 3"
    csplit -k "/tmp/test.txt" '/^$/' "{*}" -f "/tmp/llq/test3_"
    test -f "/tmp/llq/test3_00"
    CHECK_RESULT $? 0 0 "The return value is not 1"
    LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf /tmp/test.txt
  rm -rf /tmp/llq
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
