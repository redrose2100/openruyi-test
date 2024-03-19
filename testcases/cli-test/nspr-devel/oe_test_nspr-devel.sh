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
# @Date      :   2024/03/19
# @License   :   Mulan PSL v2
# @Desc      :   test nspr-devel
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL nspr-devel
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  nspr-config --cflags |grep nspr4 
  CHECK_RESULT $? 0 0 "Compiler option error in NSPR library"
  nspr-config --libs |grep lnspr4
  CHECK_RESULT $? 0 0 "Error in obtaining linker options for NSPR library"
  nspr-config --version |grep 35
  CHECK_RESULT $? 0 0 "Error in obtaining version information of NSPR library"
  nspr-config --prefix |grep usr
  CHECK_RESULT $? 0 0 "Error getting installation path for NSPR library"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
