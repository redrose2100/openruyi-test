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
# @Date      :   2024/01/25
# @License   :   Mulan PSL v2
# @Desc      :   test  linkchecker
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL linkchecker
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  linkchecker  https://gitlab.com | grep -i 'Valid: 200 OK'
  CHECK_RESULT $? 0 0 "Test single URL failed."
  linkchecker -r 2  https://gitlab.com | grep -i 'Valid: 200 OK'
  CHECK_RESULT $? 0 0 "Failed to specify recursion depth"
  
  touch linkchecker-out.html
  chmod 777 linkchecker-out.html
  linkchecker -F html https://gitlab.com | grep -i 'Valid: 200 OK'
  CHECK_RESULT $? 0 0 "Failed to specify output format as HTML"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -f linkchecker-out.html
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
