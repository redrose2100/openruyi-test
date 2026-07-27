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
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-16
# @License   :   Mulan PSL v2
# @Desc      :   libsemanage API test (C program)
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libsemanage libsemanage-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Create a simple C test program to verify libsemanage API
    cat > /tmp/test_libsemanage.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <semanage/semanage.h>

int main() {
    semanage_handle_t *handle = NULL;
    int rc;
    
    // Initialize libsemanage handle
    handle = semanage_handle_create();
    if (!handle) {
        printf("RESULT: FAIL\n");
        printf("Error: Failed to create semanage handle\n");
        return 1;
    }
    
    // Connect to the semanage store
    rc = semanage_connect(handle);
    if (rc < 0) {
        printf("RESULT: FAIL\n");
        printf("Error: Failed to connect to semanage store (rc=%d)\n", rc);
        semanage_handle_destroy(handle);
        return 1;
    }
    
    // Disconnect
    semanage_disconnect(handle);
    
    // Destroy handle
    semanage_handle_destroy(handle);
    
    printf("RESULT: PASS\n");
    printf("libsemanage API test passed\n");
    return 0;
}
EOF
    
    # Step 2: Compile the test program
    gcc /tmp/test_libsemanage.c -o /tmp/test_libsemanage -lsemanage 2>&1
    CHECK_RESULT $? 0 0 "Failed to compile test program"
    
    # Step 3: Run the test program
    /tmp/test_libsemanage | grep "RESULT: PASS"
    CHECK_RESULT $? 0 0 "libsemanage API test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/test_libsemanage.c /tmp/test_libsemanage
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"