#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2025/11/12
# @License   :   Mulan PSL v2
# @Desc      :   test zsh
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "zsh"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    zsh --version |grep zsh 
    CHECK_RESULT $? 0 0 "Check for version information errors"
    zsh --help |grep zsh 
    CHECK_RESULT $? 0 0 "Check for errors in the help information"
    zsh -c "echo 'Hello ZSH'"
    CHECK_RESULT $? 0 0 "Basic startup test failed"
    zsh -c "exit 0"   
    CHECK_RESULT $? 0 0 "Exit status test failed"
    zsh -c "ls -la"
    CHECK_RESULT $? 0 0 "Failed to execute simple command"
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  # shellcheck disable=SC2119
  DNF_REMOVE
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
