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
# @Desc      :   APR memory pool management test including hash table operations
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

TEST_DIR="/tmp/apr_memory_pool_test"

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
    LOG_INFO "Start to run APR memory pool management tests."
    
    cd $TEST_DIR || exit
    
    # Test: Advanced Memory Pool Management
    LOG_INFO "Test: Advanced Memory Pool Management"
    cat > test_memory_pool.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <apr_general.h>
#include <apr_pools.h>
#include <apr_hash.h>

int main() {
    apr_pool_t *pool;
    apr_status_t rv;
    apr_hash_t *hash;
    char *key1, *key2, *value1, *value2;
    apr_hash_index_t *hi;
    void *val;
    const void *key;
    
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
    
    // Create hash table
    hash = apr_hash_make(pool);
    
    // Allocate memory for keys and values
    key1 = apr_pstrdup(pool, "key1");
    key2 = apr_pstrdup(pool, "key2");
    value1 = apr_pstrdup(pool, "value1");
    value2 = apr_pstrdup(pool, "value2");
    
    // Add entries to hash
    apr_hash_set(hash, key1, APR_HASH_KEY_STRING, value1);
    apr_hash_set(hash, key2, APR_HASH_KEY_STRING, value2);
    
    // Test hash retrieval
    char *retrieved = apr_hash_get(hash, "key1", APR_HASH_KEY_STRING);
    if (retrieved && strcmp(retrieved, "value1") == 0) {
        printf("Memory pool and hash test: SUCCESS\n");
    } else {
        printf("Memory pool and hash test: FAILED\n");
        return -1;
    }
    
    // Test hash iteration
    int count = 0;
    for (hi = apr_hash_first(pool, hash); hi; hi = apr_hash_next(hi)) {
        apr_hash_this(hi, &key, NULL, &val);
        count++;
    }
    
    if (count == 2) {
        printf("Hash iteration test: SUCCESS\n");
    } else {
        printf("Hash iteration test: FAILED\n");
        return -1;
    }
    
    // Test memory allocation
    char *allocated = apr_palloc(pool, 1024);
    if (allocated != NULL) {
        strcpy(allocated, "Memory allocation test");
        printf("Memory allocation test: SUCCESS\n");
    } else {
        printf("Memory allocation test: FAILED\n");
        return -1;
    }
    
    // Test string duplication
    char *duplicated = apr_pstrdup(pool, "String duplication test");
    if (duplicated && strcmp(duplicated, "String duplication test") == 0) {
        printf("String duplication test: SUCCESS\n");
    } else {
        printf("String duplication test: FAILED\n");
        return -1;
    }
    
    // Cleanup
    apr_pool_destroy(pool);
    apr_terminate();
    
    printf("All memory pool tests passed successfully!\n");
    return 0;
}
EOF

    gcc test_memory_pool.c -o test_memory_pool -I /usr/include/apr-1 -L /usr/lib64 -lapr-1
    CHECK_RESULT $? 0 0 "Memory pool test compilation failed"
    
    ./test_memory_pool
    CHECK_RESULT $? 0 0 "Memory pool test execution failed"
    
    # Verify output contains success messages
    ./test_memory_pool | grep -q "SUCCESS"
    CHECK_RESULT $? 0 0 "Memory pool test output verification failed"
    
    LOG_INFO "Finish APR memory pool management tests!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $TEST_DIR
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
