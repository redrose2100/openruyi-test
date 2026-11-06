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
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2024/1/16
# @License   :   Mulan PSL v2
# @Desc      :   test gawk
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
    DNF_INSTALL "diffutils"
  DNF_INSTALL "gawk"
  cat  > data.txt  << EOF
hello world
goodbye world
nothing to do
EOF
  cat  > data1.txt  << EOF
The data File Contents:
hello world
goodbye world
nothing to do
End of File
EOF
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  CHECK_RESULT "$(echo "My name is Rich" | gawk '{$4="Christine"; print $0}' )" "My name is Christine" 0 "change specific word failed"
  gawk 'BEGIN {print "The data File Contents:"};{print $0};END {print "End of File"}' data.txt > data2.txt
  diff data1.txt data2.txt
  CHECK_RESULT $? 0 0 "test begin-end failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ./data*.txt 
  LOG_INFO "Finish environment cleanup!"
}

main "$@"


