#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangxi
# @Contact   :   yangxi@uniontech.com
# @Date      :   2026/3/04
# @License   :   Mulan PSL v2
# @Desc      :   test indent
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "diffutils indent"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # 测试 K&R 风格
    cp common/code.c ./code_kr.c
    indent -kr code_kr.c
    CHECK_RESULT $? 0 0 "K&R style indent execution failed"
    # K&R风格特点：函数括号后直接跟{，中间有空格
    grep -E "\)\s+\{" code_kr.c > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "K&R style verification failed: expected ') {' pattern"
    
    # 准备测试文件（简单的if-else结构）
    cat > test_indent.c << 'EOF'
#include <stdio.h>
int main() {
if (1 > 0) {
printf("test\n");
}
return 0;
}
EOF
    
    # 测试自定义宽度缩进
    cp test_indent.c ./code_width4.c
    indent -i4 -ci4 -lp code_width4.c
    CHECK_RESULT $? 0 0 "Custom width 4 indent execution failed"
    # 验证文件中有4个空格的缩进（至少有一行以4个空格开头）
    grep -E "^ {4}" code_width4.c > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "No line with 4-space indentation found"
    
    # 测试 Linux 内核风格
    cp common/code.c ./code_linux.c
    indent -linux code_linux.c
    CHECK_RESULT $? 0 0 "Linux style indent execution failed"
    # Linux内核风格特点：8空格缩进，特定的大括号位置
    grep -E "if \(" code_linux.c > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Linux style verification failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./*.c ./*.c~
    # shellcheck disable=SC2119 
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main "$@"

