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
# @Desc      :   test leptonica
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "leptonica leptonica-devel leptonica-tools"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  leptonica-fileinfo 1.png 2>&1 | grep -i "input image format type: png"
  CHECK_RESULT $? 0 0 "png Recognition failure"
  leptonica-convertformat 1.png 1.bmp
  test -e 1.bmp
  CHECK_RESULT $? 0 0 "Conversion failure"
  leptonica-fileinfo 1.bmp 2>&1 | grep -i "input image format type: bmp"
  CHECK_RESULT $? 0 0 "bmp Recognition failure"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE
  rm -rf  1.bmp
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
