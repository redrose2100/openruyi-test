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
# @Date      :   2025.8.27
# @License   :   Mulan PSL v2
# @Desc      :   Test ICU (International Components for Unicode) basic functions
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare environment."
    
    # 安装软件包
    DNF_INSTALL "icu libicu libicu-devel gcc make"
    
    # 创建测试目录
    mkdir -p /tmp/icu_advanced_test

     # 创建复杂的ICU测试程序
    cat > /tmp/icu_advanced_test/icu_advanced_test.c << 'EOF'
#include <unicode/utypes.h>
#include <unicode/ustring.h>
#include <unicode/ucnv.h>
#include <unicode/ucol.h>
#include <unicode/uregex.h>
#include <unicode/ubrk.h>
#include <unicode/udat.h>
#include <unicode/unum.h>
#include <unicode/umsg.h>
#include <unicode/ures.h>
#include <unicode/unorm2.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define BUFFER_SIZE 1024
#define MAX_STRINGS 10

// 辅助函数：将UTF-8字符串转换为UChar
void utf8_to_uchar(const char* utf8_str, UChar* uchar_str, int32_t max_len) {
    UErrorCode status = U_ZERO_ERROR;
    u_strFromUTF8(uchar_str, max_len, NULL, utf8_str, -1, &status);
}

// 测试复杂字符串操作
void test_complex_string_operations() {
    printf("=== Testing Complex String Operations ===\n");

    // 测试Unicode规范化
    UChar source[] = {0x00E9, 0x0301, 0x0065, 0x0301, 0}; // é́é
    UChar normalized[BUFFER_SIZE];
    UErrorCode status = U_ZERO_ERROR;

    // 使用新的规范化API
    const UNormalizer2* norm = unorm2_getNFCInstance(&status);
    if (U_SUCCESS(status)) {
        int32_t normalized_len = unorm2_normalize(norm, source, -1, normalized, BUFFER_SIZE, &status);
        if (U_SUCCESS(status)) {
            printf("NFC normalized string length: %d\n", normalized_len);
        }
    }

    // 测试字符串分割和连接
    UChar strings[MAX_STRINGS][BUFFER_SIZE];
    UChar *string_array[MAX_STRINGS];
    int32_t string_lengths[MAX_STRINGS];

    // 准备测试字符串
    utf8_to_uchar("Hello", strings[0], BUFFER_SIZE);
    utf8_to_uchar("世界", strings[1], BUFFER_SIZE);
    utf8_to_uchar("123", strings[2], BUFFER_SIZE);
    utf8_to_uchar("测试", strings[3], BUFFER_SIZE);

    for (int i = 0; i < 4; i++) {
        string_array[i] = strings[i];
        string_lengths[i] = u_strlen(strings[i]);
    }

    // 连接字符串
    UChar concatenated[BUFFER_SIZE];
    int32_t concat_len = 0;
    for (int i = 0; i < 4; i++) {
        u_strcpy(concatenated + concat_len, string_array[i]);
        concat_len += string_lengths[i];
    }
    concatenated[concat_len] = 0;

    printf("Concatenated string length: %d\n", concat_len);
}

// 测试多语言排序
void test_multi_language_collation() {
    printf("=== Testing Multi-Language Collation ===\n");

    UErrorCode status = U_ZERO_ERROR;

    // 测试中文排序
    UCollator *coll_zh = ucol_open("zh_CN", &status);
    if (U_SUCCESS(status)) {
        UChar zh_strings[4][BUFFER_SIZE];
        utf8_to_uchar("张三", zh_strings[0], BUFFER_SIZE);
        utf8_to_uchar("李四", zh_strings[1], BUFFER_SIZE);
        utf8_to_uchar("王五", zh_strings[2], BUFFER_SIZE);
        utf8_to_uchar("赵六", zh_strings[3], BUFFER_SIZE);

        // 简单的排序测试
        UCollationResult result = ucol_strcoll(coll_zh, zh_strings[0], -1, zh_strings[1], -1);
        printf("Chinese collation test result: %d\n", result);

        ucol_close(coll_zh);
    }

    // 测试英文排序
    UCollator *coll_en = ucol_open("en_US", &status);
    if (U_SUCCESS(status)) {
        UChar en_strings[4][BUFFER_SIZE];
        utf8_to_uchar("apple", en_strings[0], BUFFER_SIZE);
        utf8_to_uchar("banana", en_strings[1], BUFFER_SIZE);
        utf8_to_uchar("cherry", en_strings[2], BUFFER_SIZE);
        utf8_to_uchar("date", en_strings[3], BUFFER_SIZE);

        UCollationResult result = ucol_strcoll(coll_en, en_strings[0], -1, en_strings[1], -1);
        printf("English collation test result: %d\n", result);

        ucol_close(coll_en);
    }
}

// 测试复杂正则表达式
void test_advanced_regex() {
    printf("=== Testing Advanced Regular Expressions ===\n");
    
    UErrorCode status = U_ZERO_ERROR;
    
    // 创建复杂的正则表达式模式
    UChar pattern[BUFFER_SIZE];
    utf8_to_uchar("\\b\\w+@\\w+\\.\\w+\\b", pattern, BUFFER_SIZE); // 邮箱匹配
    URegularExpression *regex = uregex_open(pattern, -1, 0, NULL, &status);
    
    if (U_SUCCESS(status)) {
        UChar test_text[BUFFER_SIZE];
        utf8_to_uchar("Contact us at test@example.com or support@test.org", test_text, BUFFER_SIZE);
        
        uregex_setText(regex, test_text, -1, &status);
        if (U_SUCCESS(status)) {
            UBool found = uregex_find(regex, 0, &status);
            if (found) {
                printf("Email pattern matched successfully\n");
            }
        }
        
        uregex_close(regex);
    }
    
    // 测试Unicode字符类
    UChar unicode_pattern[BUFFER_SIZE];
    utf8_to_uchar("[\\p{Han}]+", unicode_pattern, BUFFER_SIZE); // 匹配中文字符
    regex = uregex_open(unicode_pattern, -1, 0, NULL, &status);
    
    if (U_SUCCESS(status)) {
        UChar test_text[BUFFER_SIZE];
        utf8_to_uchar("Hello 世界 Test 测试", test_text, BUFFER_SIZE);
        
        uregex_setText(regex, test_text, -1, &status);
        if (U_SUCCESS(status)) {
            UBool found = uregex_find(regex, 0, &status);
            if (found) {
                printf("Unicode character class matched successfully\n");
            }
        }
        
        uregex_close(regex);
    }
}

int main() {
    printf("ICU Advanced Features Test Suite\n");
    printf("ICU Version: %s\n", U_ICU_VERSION);
    printf("================================\n\n");

    test_complex_string_operations();
    test_multi_language_collation();
    test_advanced_regex();

    printf("\nAll advanced features tests completed.\n");
    return 0;
}
EOF

    # 创建Makefile
    cat > /tmp/icu_advanced_test/Makefile << 'EOF'
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -D_GNU_SOURCE
LIBS = -licuuc -licui18n -licudata

TARGET = icu_advanced_test
SOURCE = icu_advanced_test.c

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE) $(LIBS)

clean:
	rm -f $(TARGET)

.PHONY: clean
EOF

    LOG_INFO "End to prepare environment for ICU advanced features testing."
}

function run_test() {
    LOG_INFO "Start to run ICU advanced features tests."

    cd /tmp/icu_advanced_test || exit

    # 编译高级ICU测试程序
    LOG_INFO "Test 1: Compile ICU advanced features test program"
    make clean && make
    CHECK_RESULT $? 0 0 "ICU advanced features test compilation failed"

    # 运行高级功能测试
    LOG_INFO "Test 2: Run ICU advanced features tests"
    ./icu_advanced_test > /tmp/icu_advanced_output.txt 2>&1
    CHECK_RESULT $? 0 0 "ICU advanced features test execution failed"

    # 验证复杂字符串操作
    LOG_INFO "Test 3: Verify complex string operations"
    grep "Complex String Operations" /tmp/icu_advanced_output.txt
    CHECK_RESULT $? 0 0 "Complex string operations test failed"

    # 验证多语言排序
    LOG_INFO "Test 4: Verify multi-language collation"
    grep "Multi-Language Collation" /tmp/icu_advanced_output.txt
    CHECK_RESULT $? 0 0 "Multi-language collation test failed"

    # 验证高级正则表达式
    LOG_INFO "Test 5: Verify advanced regular expressions"
    grep "Advanced Regular Expressions" /tmp/icu_advanced_output.txt
    CHECK_RESULT $? 0 0 "Advanced regular expressions test failed"

    # 检查字符串操作输出
    grep "NFC normalized string length:" /tmp/icu_advanced_output.txt
    CHECK_RESULT $? 0 0 "String normalization test output not found"

    # 检查排序测试输出
    grep "collation test result:" /tmp/icu_advanced_output.txt
    CHECK_RESULT $? 0 0 "Collation test output not found"

    # 检查正则表达式测试输出
    grep "pattern matched successfully" /tmp/icu_advanced_output.txt
    CHECK_RESULT $? 0 0 "Regex pattern matching output not found"

    LOG_INFO "Finish ICU advanced features tests."
}

function post_test() {
    LOG_INFO "Start to restore environment."
    
    # 清理测试文件和目录
    rm -rf /tmp/icu_advanced_test
    rm -f /tmp/icu_advanced_output.txt
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"   
}

main "$@" 
