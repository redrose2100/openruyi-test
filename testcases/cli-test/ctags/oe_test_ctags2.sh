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
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2026/01/15
# @License   :   Mulan PSL v2
# @Desc      :   ctags additional functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ctags"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "Test point 1: C language tag generation"
    cat > test_c_code.c << 'EOF'
#include <stdio.h>

// 函数声明
int add(int a, int b);
float multiply(float x, float y);

// 结构体定义
struct Point {
    int x;
    int y;
};

// 函数实现
int add(int a, int b) {
    return a + b;
}

float multiply(float x, float y) {
    return x * y;
}

int main() {
    struct Point p = {10, 20};
    int result = add(p.x, p.y);
    printf("Result: %d\n", result);
    return 0;
}
EOF
    ctags test_c_code.c
    CHECK_RESULT $? 0 0 "Failed to generate tags for C code"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created"
    grep -E "add|multiply|Point|main" tags
    CHECK_RESULT $? 0 0 "Tags file does not contain expected symbols"
    
    LOG_INFO "Test point 2: Python language tag generation"
    cat > test_python_code.py << 'EOF'
class Calculator:
    """A simple calculator class"""
    
    def __init__(self):
        self.result = 0
    
    def add(self, a, b):
        """Add two numbers"""
        return a + b
    
    def subtract(self, a, b):
        """Subtract two numbers"""
        return a - b

def main_function():
    """Main function"""
    calc = Calculator()
    result = calc.add(5, 3)
    print(f"Result: {result}")

if __name__ == "__main__":
    main_function()
EOF
    rm -f tags
    ctags test_python_code.py
    CHECK_RESULT $? 0 0 "Failed to generate tags for Python code"
    test -f tags
    CHECK_RESULT $? 0 0 "Tags file not created for Python"
    grep -E "Calculator|add|subtract|main_function" tags
    CHECK_RESULT $? 0 0 "Tags file does not contain expected Python symbols"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf test_c_code.c test_python_code.py test_c_code2.c tags custom_tags subdir
    LOG_INFO "Finish restoring the test environment."
}

main "$@"