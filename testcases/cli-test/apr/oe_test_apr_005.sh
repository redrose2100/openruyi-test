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
# @Author    :   caowenqian
# @Contact   :   caowenqian@uniontech.com
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   APR utility functions test including string formatting, time functions, and string operations
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_DIR="/tmp/apr_utility_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    # Install required packages
    DNF_INSTALL "apr apr-devel apr-util apr-util-devel gcc"
    
    # Create test directory
    mkdir -p $TEST_DIR
    cd $TEST_DIR || exit
    
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run APR utility functions tests."
    
    cd $TEST_DIR || exit
    
    # Test: APR Utility Functions
    LOG_INFO "Test: APR Utility Functions"
    cat > test_apr_util.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <apr_general.h>
#include <apr_pools.h>
#include <apr_strings.h>
#include <apr_time.h>
#include <apr_tables.h>

int main() {
    apr_pool_t *pool;
    apr_status_t rv;
    char *formatted_time;
    apr_time_t now;
    
    // Initialize APR
    rv = apr_initialize();
    if (rv != APR_SUCCESS) {
        printf("APR initialization failed\n");
        return -1;
    }
    
    // Create memory pool
    rv = apr_pool_create(&pool, NULL);
    if (rv != APR_SUCCESS) {
        printf("Pool creation failed\n");
        return -1;
    }
    
    // Test 1: String formatting
    char *formatted = apr_psprintf(pool, "Test string: %s, number: %d", "hello", 42);
    if (strstr(formatted, "Test string: hello, number: 42") != NULL) {
        printf("String formatting test: SUCCESS\n");
    } else {
        printf("String formatting test: FAILED\n");
        return -1;
    }
    
    // Test 2: Time functions
    now = apr_time_now();
    formatted_time = apr_psprintf(pool, "%" APR_TIME_T_FMT, now);
    if (strlen(formatted_time) > 0) {
        printf("Time formatting test: SUCCESS\n");
    } else {
        printf("Time formatting test: FAILED\n");
        return -1;
    }
    
    // Test 3: String concatenation
    char *str1 = apr_pstrdup(pool, "Hello");
    char *str2 = apr_pstrdup(pool, " World");
    char *concatenated = apr_pstrcat(pool, str1, str2, NULL);
    if (strcmp(concatenated, "Hello World") == 0) {
        printf("String concatenation test: SUCCESS\n");
    } else {
        printf("String concatenation test: FAILED\n");
        return -1;
    }
    
    // Test 4: String duplication
    char *original = "Test string for duplication";
    char *duplicated = apr_pstrdup(pool, original);
    if (strcmp(duplicated, original) == 0) {
        printf("String duplication test: SUCCESS\n");
    } else {
        printf("String duplication test: FAILED\n");
        return -1;
    }
    
    // Test 5: Array operations
    apr_array_header_t *array = apr_array_make(pool, 10, sizeof(char*));
    if (array != NULL) {
        char *item1 = "Item1";
        char *item2 = "Item2";
        char *item3 = "Item3";
        
        APR_ARRAY_PUSH(array, char*) = item1;
        APR_ARRAY_PUSH(array, char*) = item2;
        APR_ARRAY_PUSH(array, char*) = item3;
        
        if (array->nelts == 3) {
            printf("Array operations test: SUCCESS\n");
        } else {
            printf("Array operations test: FAILED\n");
            return -1;
        }
    } else {
        printf("Array creation test: FAILED\n");
        return -1;
    }
    
    // Test 6: String case conversion (using ctype.h)
    char *lower_str = apr_pstrdup(pool, "HELLO WORLD");
    char *upper_str = apr_pstrdup(pool, "hello world");

    for (char *p = lower_str; *p; ++p) { *p = (char)tolower((unsigned char)*p); }
    for (char *p = upper_str; *p; ++p) { *p = (char)toupper((unsigned char)*p); }

    if (strcmp(lower_str, "hello world") == 0 && strcmp(upper_str, "HELLO WORLD") == 0) {
        printf("String case conversion test: SUCCESS\n");
    } else {
        printf("String case conversion test: FAILED\n");
        return -1;
    }
    
    // Test 7: Time arithmetic
    apr_time_t time1 = apr_time_now();
    apr_time_t time2 = apr_time_now();
    apr_time_t diff = time2 - time1;
    
    if (diff >= 0) {
        printf("Time arithmetic test: SUCCESS\n");
    } else {
        printf("Time arithmetic test: FAILED\n");
        return -1;
    }
    
    // (Removed non-portable memory pool statistics test)
    
    // Cleanup
    apr_pool_destroy(pool);
    apr_terminate();
    
    printf("All utility function tests passed successfully!\n");
    return 0;
}
EOF

    gcc test_apr_util.c -o test_apr_util -I /usr/include/apr-1 -L /usr/lib64 -lapr-1
    CHECK_RESULT $? 0 0 "APR utility test compilation failed"
    
    ./test_apr_util
    CHECK_RESULT $? 0 0 "APR utility test execution failed"
    
    # Verify output contains success messages
    ./test_apr_util | grep -q "SUCCESS"
    CHECK_RESULT $? 0 0 "APR utility test output verification failed"
    
    # Test additional utility functions via command line
    LOG_INFO "Test: Additional APR utility functions via command line"
    
    # Test apr-1-config
    apr-1-config --version
    CHECK_RESULT $? 0 0 "apr-1-config version check failed"
    
    apr-1-config --cflags
    CHECK_RESULT $? 0 0 "apr-1-config cflags check failed"
    
    apr-1-config --libs
    CHECK_RESULT $? 0 0 "apr-1-config libs check failed"
    
    # Test apr-util config tool (apr-util-1-config or apu-1-config)
    if command -v apr-util-1-config >/dev/null 2>&1; then
        APR_UTIL_CONFIG=apr-util-1-config
    elif command -v apu-1-config >/dev/null 2>&1; then
        APR_UTIL_CONFIG=apu-1-config
    else
        LOG_WARN "apr-util config tool not found; skipping apr-util CLI checks"
        APR_UTIL_CONFIG=""
    fi

    if [ -n "$APR_UTIL_CONFIG" ]; then
        $APR_UTIL_CONFIG --version
        CHECK_RESULT $? 0 0 "$APR_UTIL_CONFIG version check failed"

        if [ "$APR_UTIL_CONFIG" = "apu-1-config" ]; then
            $APR_UTIL_CONFIG --includes
            CHECK_RESULT $? 0 0 "$APR_UTIL_CONFIG includes check failed"
            $APR_UTIL_CONFIG --ldflags
            CHECK_RESULT $? 0 0 "$APR_UTIL_CONFIG ldflags check failed"
        else
            $APR_UTIL_CONFIG --cflags
            CHECK_RESULT $? 0 0 "$APR_UTIL_CONFIG cflags check failed"
        fi

        $APR_UTIL_CONFIG --libs
        CHECK_RESULT $? 0 0 "$APR_UTIL_CONFIG libs check failed"
    fi
    
    LOG_INFO "Finish APR utility functions tests!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $TEST_DIR
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
