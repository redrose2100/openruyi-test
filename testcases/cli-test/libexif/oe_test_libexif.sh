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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/04/06
# @License   :   Mulan PSL v2
# @Desc      :   test libexif
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  mkdir /tmp/test
  path=/tmp/test
  DNF_INSTALL "libexif libexif-devel gcc"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cp ./common/example* ${path}
  cd ${path} && gcc example.c -lexif -o example
  CHECK_RESULT $? 0 0 "Example.c file compilation failure"
  ./example | grep -e "Unable to load EXIF data" -e "无法加载EXIF数据"
  CHECK_RESULT $? 1 0 "EXIF data for the image can be loaded"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf ${path}
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
