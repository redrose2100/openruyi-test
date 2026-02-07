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
    
    # 新增1：测试脚本文件执行
    echo "echo 'Script execution test'" > /tmp/test_zsh_script.sh
    zsh /tmp/test_zsh_script.sh 2>/dev/null | grep -q "Script execution test"
    CHECK_RESULT $? 0 0 "Check script file execution"
    
    # 新增2：测试交互模式
    echo "exit" | zsh -i -c "echo 'Interactive mode'" 2>/dev/null
    CHECK_RESULT $? 0 0 "Check interactive mode"
    
    # 新增3：测试扩展glob选项
    zsh -o extendedglob -c "echo 'Extended glob enabled'" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Check extended glob option functionality"
    
    LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -f /tmp/test_zsh_script.sh
  # shellcheck disable=SC2119
  DNF_REMOVE
  LOG_INFO "Finish environment cleanup!"
}

main "$@"

