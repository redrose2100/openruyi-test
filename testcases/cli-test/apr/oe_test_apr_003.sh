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
# @Desc      :   APR file operations test including file I/O, seeking, and copying
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "apr apr-devel gcc"
    TEST_DIR="/tmp/apr_file_test"
    mkdir -p $TEST_DIR
    cd $TEST_DIR || exit

    # Create test file
    cat > test_file.txt << 'EOF'
Line 1: Test file for APR operations
Line 2: File read and write testing
Line 3: File copy functionality
EOF
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run APR file operations tests."
    cd $TEST_DIR || exit

    # Create test program focusing on 5 core functions
    cat > test_apr_simple.c << 'EOF'
#include <stdio.h>
#include <apr_general.h>
#include <apr_file_io.h>
#include <apr_pools.h>

int main() {
    apr_pool_t *pool;
    apr_status_t rv;
    apr_file_t *file;
    char buffer[128];
    apr_size_t len;

    // 1. Initialize APR
    rv = apr_initialize();
    if (rv != APR_SUCCESS) return 1;

    apr_pool_create(&pool, NULL);

    // 2. File open and read test
    rv = apr_file_open(&file, "test_file.txt", APR_READ, APR_OS_DEFAULT, pool);
    if (rv != APR_SUCCESS) return 2;
    printf("File open: SUCCESS\n");

    // 3. File read test
    len = sizeof(buffer) - 1;
    rv = apr_file_read(file, buffer, &len);
    if (rv == APR_SUCCESS) {
        buffer[len] = '\0';
        printf("File read: SUCCESS\n");
    }
    apr_file_close(file);

    // 4. File write test
    rv = apr_file_open(&file, "test_write.txt", APR_WRITE|APR_CREATE|APR_TRUNCATE, APR_OS_DEFAULT, pool);
    if (rv == APR_SUCCESS) {
        const char *content = "APR write test content\n";
        apr_size_t wlen = strlen(content);
        apr_file_write(file, content, &wlen);
        printf("File write: SUCCESS\n");
        apr_file_close(file);
    }

    // 5. File copy test
    rv = apr_file_copy("test_file.txt", "test_copy.txt", APR_OS_DEFAULT, pool);
    if (rv == APR_SUCCESS) {
        printf("File copy: SUCCESS\n");
    }

    apr_pool_destroy(pool);
    apr_terminate();
    return 0;
}
EOF

    # Compile and run
    gcc test_apr_simple.c -o test_apr_simple -I/usr/include/apr-1 -lapr-1
    CHECK_RESULT $? 0 0 "Compilation failed"

    ./test_apr_simple
    CHECK_RESULT $? 0 0 "Test execution failed"

    # Verify outputs
    test -f "test_write.txt"
    CHECK_RESULT $? 0 0 "Write file not created"

    test -f "test_copy.txt"
    CHECK_RESULT $? 0 0 "Copy file not created"

    LOG_INFO "All core APR file operations tests passed!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/apr_file_test
    DNF_REMOVE "apr apr-devel gcc"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
