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
# @Date      :   2025.8.6
# @License   :   Mulan PSL v2
# @Desc      :   Test ICU (International Components for Unicode) basic functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    
    # 安装软件包
    DNF_INSTALL "icu libicu libicu-devel gcc"
    
    # 创建测试文件
    cat > /tmp/icu_test.c << EOF
#include <unicode/utypes.h>
#include <unicode/ustring.h>
#include <unicode/ucnv.h>
#include <stdio.h>

int main() {
    // 1. 简单ICU版本检查
    printf("ICU version: %s\n", U_ICU_VERSION);
    
    // 2. 测试Unicode字符串转换
    UChar unicodeStr[] = {0x4F60, 0x597D, 0x4E16, 0x754C, 0}; // 你好世界
    char utf8Str[50] = {0};
    UErrorCode status = U_ZERO_ERROR;
    
    // 将Unicode字符串转换为UTF-8
    u_strToUTF8(utf8Str, sizeof(utf8Str), NULL, unicodeStr, -1, &status);
    
    if(U_SUCCESS(status)) {
        printf("UTF-8 string: %s\n", utf8Str);
    } else {
        printf("Error converting string: %s\n", u_errorName(status));
    }
    
    return 0;
}
EOF
    
    LOG_INFO "End to prepare environment."
}

function run_test() {
    LOG_INFO "Start to run ICU basic function tests."

    # 编译测试程序
    cd /tmp || exit
    gcc icu_test.c -o icu_test -licuuc -licui18n
    CHECK_RESULT $? 0 0 "ICU test compilation failed"

    # 运行测试程序
    ./icu_test | grep "UTF-8 string: 你好世界"
    CHECK_RESULT $? 0 0 "ICU test execution failed"
    
    LOG_INFO "Finish ICU basic function tests."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    
    # 清理测试文件
    rm -f /tmp/icu_test.c
    rm -f /tmp/icu_test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"   
}

main "$@" 
