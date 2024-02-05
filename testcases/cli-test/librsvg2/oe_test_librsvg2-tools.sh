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
# @Author    :   wangxiaorou
# @Contact   :   wangxiaorou@uniontech.com
# @Date      :   2024/02/05
# @License   :   Mulan PSL v2
# @Desc      :   test librsvg2-tools
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "librsvg2 librsvg2-tools"
  rm -rf ./example.svg  ./out.png
  cp "$(find /usr -name "*.svg"  |tail -1)" ./example.svg
  file ./example.svg
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  rsvg-convert --help
  CHECK_RESULT $? 0 0 "display help information failed"
  rsvg-convert example.svg -o out.png
  CHECK_RESULT $? 0 0 "switch type failed"
  file ./out.png |grep -i "PNG image data"
  CHECK_RESULT $? 0 0 "The converted file type is incorrect"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ./example.svg  ./out.png
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
