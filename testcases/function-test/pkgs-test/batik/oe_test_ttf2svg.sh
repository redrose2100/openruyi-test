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
# @Date      :   2023/12/16
# @License   :   Mulan PSL v2
# @Desc      :   test ttf2svg
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "batik javapackages-tools"
  tff_filename=$(find /usr/share -name "*.ttf" |tail -1)
  ls ./example.svg && rm -rf ./example.svg
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  ttf2svg "${tff_filename}" -o example.svg
  CHECK_RESULT $? 0 0 "chage failed"
  ls ./example.svg
  CHECK_RESULT $? 0 0 "create svg failed"
  ttf2svg --help
  CHECK_RESULT $? 0 0 "display help information failed"
  ttf2svg "${tff_filename}" -o char.svg -l 65 -h 65  # ASCII 65 = 'A'
  CHECK_RESULT $? 0 0 "convert specific character failed"
  grep -q "<svg" char.svg
  CHECK_RESULT $? 0 0 "generated SVG does not contain valid SVG tag"
  ttf2svg "${tff_filename}" -o id.svg -id "custom-font"
  CHECK_RESULT $? 0 0 "set font ID failed"
  grep -q "id=\"custom-font\"" id.svg
  CHECK_RESULT $? 0 0 "font ID parameter not applied"
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
