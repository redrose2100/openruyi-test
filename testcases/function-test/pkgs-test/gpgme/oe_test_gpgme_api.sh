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
# @Date      :   2026-07-17
# @License   :   Mulan PSL v2
# @Desc      :   gpgme C API test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gpgme gpgme-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Create a simple C test program to verify gpgme API
    cat > /tmp/test_gpgme.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <gpgme.h>

int main() {
    gpgme_ctx_t ctx = NULL;
    gpgme_error_t err;
    const char *version;
    
    // Initialize gpgme
    gpgme_check_version(NULL);
    version = gpgme_check_version(NULL);
    printf("gpgme version: %s\n", version);
    
    // Create context
    err = gpgme_new(&ctx);
    if (err != GPG_ERR_NO_ERROR) {
        printf("RESULT: FAIL\n");
        printf("Error: Failed to create gpgme context: %s\n", gpgme_strerror(err));
        return 1;
    }
    
    // Set protocol
    err = gpgme_set_protocol(ctx, GPGME_PROTOCOL_OpenPGP);
    if (err != GPG_ERR_NO_ERROR) {
        printf("RESULT: FAIL\n");
        printf("Error: Failed to set protocol: %s\n", gpgme_strerror(err));
        gpgme_release(ctx);
        return 1;
    }
    
    // Release context
    gpgme_release(ctx);
    
    printf("RESULT: PASS\n");
    printf("gpgme C API test passed\n");
    return 0;
}
EOF
    
    # Step 2: Compile the test program
    gcc /tmp/test_gpgme.c -o /tmp/test_gpgme -lgpgme 2>&1
    CHECK_RESULT $? 0 0 "Failed to compile test program"
    
    # Step 3: Run the test program
    /tmp/test_gpgme | grep "RESULT: PASS"
    CHECK_RESULT $? 0 0 "gpgme C API test failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f /tmp/test_gpgme.c /tmp/test_gpgme
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"