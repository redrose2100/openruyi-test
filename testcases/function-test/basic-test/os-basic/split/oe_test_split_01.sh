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
# @Date      :   2024/05/07
# @License   :   Mulan PSL v2
# @Desc      :   split case
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  mkdir -p /tmp/llq
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > /tmp/llq/largefile.txt << EOF
This is a sample text for largefile.txt
EOF

  split -b 1M /tmp/llq/largefile.txt /tmp/llq/splitfile_   
  test -f "/tmp/llq/splitfile_aa"
  CHECK_RESULT $? 0  0 "The return value is not 1"
  split -l 10 /tmp/llq/largefile.txt /tmp/llq/splitdata_
  test -f "/tmp/llq/splitdata_aa"
  CHECK_RESULT $? 0 0 "The return value is not 2"
  split -d -l 10 /tmp/llq/largefile.txt /tmp/llq/logfile_
  test -f "/tmp/llq/logfile_00"
  CHECK_RESULT $? 0 0 "The return value is not 3"
  LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf /tmp/llq
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
