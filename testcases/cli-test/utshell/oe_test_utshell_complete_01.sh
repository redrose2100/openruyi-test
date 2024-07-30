#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2024.05.22
# @License   :   Mulan PSL v2
# @Desc      :   compelte using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "utshell"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "complete -o default "|grep watch
  CHECK_RESULT $? 0 0 "bind --help fail"
  utshell -c "bind -l"|grep -i abort
  CHECK_RESULT $? 0 0 "bind -l fail"
  utshell -c "bind -p"|grep -i bound
  CHECK_RESULT $? 0 0 "bind -p fail"
  utshell -c "bind -v"|grep -i set
  CHECK_RESULT $? 0 0 "bind -v fail"
  utshell -c "bind -q abort"|grep -i C-g
  CHECK_RESULT $? 0 0 "bind -q abort fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
