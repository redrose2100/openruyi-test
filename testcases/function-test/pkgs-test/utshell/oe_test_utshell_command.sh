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
# @Author    :   lixintao
# @Contact   :   lixintao@uniontech.com
# @Date      :   2024.8.06
# @License   :   Mulan PSL v2
# @Desc      :   eval using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "command --help"
  CHECK_RESULT $? 2 0 "command --help fail"
  utshell -c "command fdisk -l"|grep -e Disk
  CHECK_RESULT $? 0 0 "command fdisk -l fail"
  utshell -c "command echo Linuxcool"|grep -e Linuxcool
  CHECK_RESULT $? 0 0 "command echo Linuxcool fail"
  utshell -c "command -p fdisk -l"|grep -e Disk
  CHECK_RESULT $? 0 0 "command -p fdisk -l fail"
  utshell -c "command -v fdisk -l"|grep fdisk
  CHECK_RESULT $? 0 0 "command -v fdisk -l fail"
  utshell -c "command -V fdisk"|grep fdisk
  CHECK_RESULT $? 0 0 "command -V fdisk fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"