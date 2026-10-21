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
# @Author    :   wangxiaorou
# @Contact   :   wangxiaorou@uniontech.com
# @Date      :   2023/12/29
# @License   :   Mulan PSL v2
# @Desc      :   test gawk
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "gawk"
  cat  > data.txt  << EOF
hello world
goodbye world
nothing to do
EOF
  cp data.txt data1.txt
  sed -i 's/world/orange/g' data1.txt
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  gawk -h
  CHECK_RESULT $? 0 0 "display help information failed"
  CHECK_RESULT "$(gawk '{print $1}' data.txt |xargs)" "hello goodbye nothing" 0 "display first column failed"
  CHECK_RESULT "$(gawk '{gsub(/world/, "orange")} {print}' data.txt)" "$(cat data1.txt)" 0 "chage world for data.txt failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ./data1.txt ./data.txt
  LOG_INFO "Finish environment cleanup!"
}

main "$@"


