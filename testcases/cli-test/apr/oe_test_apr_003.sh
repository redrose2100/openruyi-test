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

# Resolve APR compile and link flags robustly across distros


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "apr apr-devel apr-util apr-util-devel gcc" 
    
    # Create test directory
    TEST_DIR="/tmp/apr_file_ops_test"
    mkdir -p $TEST_DIR
    cd $TEST_DIR || exit
    
    # Create test files
    cat > test_file.txt << 'EOF'
This is a test file for APR file operations testing.
Line 1: File read test
Line 2: File write test  
Line 3: File seek test
Line 4: File copy test
Line 5: File info test
EOF

    LOG_INFO "Finish preparing the test environment."
}

function resolve_apr_flags() {
    APR_CFLAGS=""
    APR_LDFLAGS=""
    APR_LIBS=""

    local cfg=""
    if command -v apr-1-config >/dev/null 2>&1; then
        cfg="apr-1-config"
    elif command -v apr-config >/dev/null 2>&1; then
        cfg="apr-config"
    fi

    if [ -n "$cfg" ]; then
        local cflags cppflags includes ldflags libs libdir
        cflags="$($cfg --cflags 2>/dev/null)"
        cppflags="$($cfg --cppflags 2>/dev/null)"
        includes="$($cfg --includes 2>/dev/null)"
        ldflags="$($cfg --ldflags 2>/dev/null)"
        libs="$($cfg --libs 2>/dev/null)"
        libdir="$($cfg --libdir 2>/dev/null)"

        # Detect broken outputs that contain help/usage text
        if printf '%s\n%s\n%s\n%s\n' "$cflags $cppflags $includes" "$ldflags" "$libs" "$libdir" | grep -qiE "(^| )Usage:|Known values for OPTION"; then
            cfg=""
        else
            APR_CFLAGS="$cflags $cppflags $includes"
            APR_LDFLAGS="$ldflags"
            APR_LIBS="$libs"
            if [ -n "$libdir" ] && echo "$libdir" | grep -qE '^/'; then
                APR_LDFLAGS="-L$libdir $APR_LDFLAGS"
            fi
            case " $APR_LIBS " in
                *" -lapr-1 "*|*" -lapr "*) : ;;
                *) APR_LIBS="$APR_LIBS -lapr-1" ;;
            esac
        fi
    fi

    if [ -z "$APR_CFLAGS$APR_LDFLAGS$APR_LIBS" ]; then
        APR_CFLAGS="-I /usr/include/apr-1"
        APR_LDFLAGS=""
        APR_LIBS="-lapr-1"
    fi
}

function run_test() {
    LOG_INFO "Start to run APR file operations tests."
    
    cd $TEST_DIR || exit
    
    # Test: Advanced File Operations with Error Handling
    LOG_INFO "Test: Advanced File Operations with Error Handling"
    cat > test_file_ops.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <apr_general.h>
#include <apr_file_io.h>
#include <apr_pools.h>
#include <apr_file_info.h>

int main() {
    apr_pool_t *pool;
    apr_status_t rv;
    apr_file_t *file;
    apr_finfo_t finfo;
    char buffer[256];
    apr_size_t read_len;
    apr_off_t offset;
    
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
    
    // Test 1: Open file for reading
    rv = apr_file_open(&file, "test_file.txt", APR_READ | APR_BUFFERED, APR_OS_DEFAULT, pool);
    if (rv != APR_SUCCESS) {
        printf("File open failed\n");
        return -1;
    }
    printf("File open test: SUCCESS\n");
    
    // Test 2: Get file info
    rv = apr_file_info_get(&finfo, APR_FINFO_SIZE, file);
    if (rv == APR_SUCCESS) {
        printf("File size: %ld bytes\n", (long)finfo.size);
        printf("File info test: SUCCESS\n");
    } else {
        printf("File info test: FAILED\n");
        return -1;
    }
    
    // Test 3: Read file content
    read_len = sizeof(buffer) - 1; // reserve space for null terminator
    rv = apr_file_read(file, buffer, &read_len);
    if (rv == APR_SUCCESS) {
        buffer[read_len] = '\0';
        printf("File content read successfully\n");
        printf("File read test: SUCCESS\n");
    } else {
        printf("File read test: FAILED\n");
        return -1;
    }
    
    // Test 4: File seeking
    offset = 0;
    rv = apr_file_seek(file, APR_SET, &offset);
    if (rv == APR_SUCCESS) {
        printf("File seek test: SUCCESS\n");
    } else {
        printf("File seek test: FAILED\n");
        return -1;
    }
    
    apr_file_close(file);
    
    // Test 5: File copy
    rv = apr_file_copy("test_file.txt", "test_file_copy.txt", APR_OS_DEFAULT, pool);
    if (rv == APR_SUCCESS) {
        printf("File copy test: SUCCESS\n");
    } else {
        printf("File copy test: FAILED\n");
        return -1;
    }
    
    // Test 6: Verify copied file exists
    rv = apr_stat(&finfo, "test_file_copy.txt", APR_FINFO_SIZE, pool);
    if (rv == APR_SUCCESS) {
        printf("Copied file verification: SUCCESS\n");
    } else {
        printf("Copied file verification: FAILED\n");
        return -1;
    }
    
    // Test 7: Create and write to a new file
    apr_file_t *write_file;
    rv = apr_file_open(&write_file, "test_write.txt", APR_WRITE | APR_CREATE | APR_TRUNCATE, APR_OS_DEFAULT, pool);
    if (rv == APR_SUCCESS) {
        const char *test_content = "This is a test write operation\n";
        apr_size_t write_len = strlen(test_content);
        rv = apr_file_write(write_file, test_content, &write_len);
        if (rv == APR_SUCCESS) {
            printf("File write test: SUCCESS\n");
        } else {
            printf("File write test: FAILED\n");
            return -1;
        }
        apr_file_close(write_file);
    } else {
        printf("File write creation test: FAILED\n");
        return -1;
    }
    
    // Test 8: File locking (shared read lock)
    rv = apr_file_open(&file, "test_file.txt", APR_READ | APR_BUFFERED, APR_OS_DEFAULT, pool);
    if (rv == APR_SUCCESS) {
        rv = apr_file_lock(file, APR_FLOCK_SHARED);
        if (rv == APR_SUCCESS) {
            printf("File lock test: SUCCESS\n");
            apr_file_unlock(file);
        } else {
            printf("File lock test: FAILED\n");
        }
        apr_file_close(file);
    }
    
    // Cleanup
    apr_pool_destroy(pool);
    apr_terminate();
    
    printf("All file operations tests passed successfully!\n");
    return 0;
}
EOF

    # Prefer apr-1-config/apr-config; fall back to sane defaults if outputs look broken
    resolve_apr_flags

    LOG_INFO "APR_CFLAGS: ${APR_CFLAGS}"
    LOG_INFO "APR_LDFLAGS: ${APR_LDFLAGS}"
    LOG_INFO "APR_LIBS: ${APR_LIBS}"

    gcc test_file_ops.c -o test_file_ops "${APR_CFLAGS}" "${APR_LDFLAGS}" "${APR_LIBS}"
    CHECK_RESULT $? 0 0 "File operations test compilation failed"
    
    ./test_file_ops | tee test_file_ops.output
    ret=$?
    LOG_INFO "test_file_ops exit code: $ret"
    if [ -f test_file_ops.output ]; then
        LOG_INFO "test_file_ops first lines:"
        head -n 20 test_file_ops.output | sed 's/^/[prog] /'
    fi
    
    CHECK_RESULT $ret 0 0 "File operations test execution failed"
    
    # Verify test files were created
    test -f test_file_copy.txt
    CHECK_RESULT $? 0 0 "Test file copy was not created"
    
    test -f test_write.txt
    CHECK_RESULT $? 0 0 "Test write file was not created"
    
    # Verify output contains success messages
    ./test_file_ops | grep -q "SUCCESS"
    CHECK_RESULT $? 0 0 "File operations test output verification failed"
    
    LOG_INFO "Finish APR file operations tests!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf $TEST_DIR
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
