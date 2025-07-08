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
# @Date      :   2024/04/07
# @License   :   Mulan PSL v2
# @Desc      :   test objectweb-asm3-processor
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL objectweb-asm3
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cd /usr/share/java/objectweb-asm3 || exit
  objectweb-asm3-processor code xml -in asm.jar -out asm.xml 
  CHECK_RESULT $? 0 0 "Error converting bytecode from code format to XML format"
  objectweb-asm3-processor xml code -in output.xml -out output.jar 
  CHECK_RESULT $? 0 0 "Error converting bytecode from XML format to code format"
  objectweb-asm3-processor xml singlexml -in output.xml -out output.xml
  CHECK_RESULT $? 0 0 "Error converting bytecode from XML format to a single XML format"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
