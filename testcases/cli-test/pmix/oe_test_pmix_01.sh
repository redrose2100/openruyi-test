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
# @Author    :   liangjiayu01
# @Contact   :   liangjiayu@uniontech.com
# @Date      :   2024/05/08
# @License   :   Mulan PSL v2
# @Desc      :   test pmix 
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
  LOG_INFO "START environment pre."
  DNF_INSTALL "pmix pmix-devel pmix-tools gcc"
  LOG_INFO "END of environment pre."
}

function run_test(){
  LOG_INFO "START to run test."
  pmix_info -a | grep MCA
  CHECK_RESULT $? 0 0 "display a information failed"
  pmix_info --pretty-print | grep Configure  
  CHECK_RESULT $? 0 0 "display pretty-print information failed"
  pmix_info --help | grep MCA 
  CHECK_RESULT $? 0 0 "display help information failed"
  pmix_info --param all all | grep MCA
  CHECK_RESULT $? 0 0 "display param all all information failed"
  LOG_INFO "END of the test."
}

function post_test(){
  LOG_INFO "START environment cleanup!"
  DNF_REMOVE "$@"
  LOG_INFO "FINISH environment cleanup!"
}

main "$@"
