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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/20
# @License   :   Mulan PSL v2
# @Desc      :   Test libfprint API interface correctness
# ############################################

# shellcheck disable=SC2119,SC2046
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_PROG="/tmp/libfprint_api_test_$(date +%s)"
    TEST_SRC="${TEST_PROG}.c"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libfprint libfprint-devel gcc make binutils"
    if [ -d "/usr/include/libfprint-2" ];then
    libfprint="libfprint-2"
    cat > "${TEST_SRC}" <<EOF
#include <stdio.h>
#include <libfprint-2/fprint.h>

int main() {
    FpContext *ctx;
    GPtrArray *devices;
    int ret = 0;

    ctx = fp_context_new();
    if (!ctx) {
        printf("FAIL: fp_context_new() returned NULL\n");
        return 1;
    }
    printf("PASS: fp_context_new() succeeded\n");

    devices = fp_context_get_devices(ctx);
    if (!devices) {
        printf("INFO: fp_context_get_devices() returned NULL (no devices available)\n");
    } else {
        printf("PASS: fp_context_get_devices() returned %d devices\n", devices->len);
        g_ptr_array_unref(devices);
    }

    g_object_ref(ctx);
    printf("PASS: g_object_ref() succeeded\n");

    g_object_unref(ctx);
    printf("PASS: g_object_unref() succeeded\n");

    return 0;
}
EOF
    else
    libfprint="libfprint"
    cat > "${TEST_SRC}" <<'EOF'
#include <stdio.h>
#include <libfprint/fprint.h>

int main() {
    struct fp_dscv_dev **discovered;
    int dev_count = 0;
    int ret;

    ret = fp_init();
    if (ret != 0) {
        printf("FAIL: fp_init() failed with error code %d\n", ret);
        return 1;
    }
    printf("PASS: fp_init() succeeded\n");

    discovered = fp_discover_devs();
    if (!discovered) {
        printf("FAIL: fp_discover_devs() returned NULL\n");
        fp_exit();
        return 1;
    }

    while (discovered[dev_count] != NULL) {
        dev_count++;
    }

    if (dev_count == 0) {
        printf("INFO: fp_discover_devs() found no devices\n");
    } else {
        printf("PASS: fp_discover_devs() found %d devices\n", dev_count);
    }

    fp_dscv_devs_free(discovered);
    printf("PASS: fp_dscv_devs_free() succeeded\n");

    fp_exit();
    printf("PASS: fp_exit() succeeded\n");

    return 0;
}
EOF
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Compile test program
    gcc "${TEST_SRC}" -o "${TEST_PROG}" $(pkg-config --cflags --libs ${libfprint})
    CHECK_RESULT $? 0 0 "Failed to compile libfprint API test"
    
    # Run test program
    "${TEST_PROG}" | grep "PASS"
    CHECK_RESULT $? 0 0 "libfprint API test failed"
    
    # Verify key API symbols exist in library
    nm -D /usr/lib64/${libfprint}.so | grep "fp_print" || \
    nm -D /usr/lib/${libfprint}.so | grep "fp_print"
    CHECK_RESULT $? 0 0 "fp_print symbol not found in libfprint"
    nm -D /usr/lib64/${libfprint}.so | grep "fp.*enroll" || \
    nm -D /usr/lib/${libfprint}.so | grep "fp.*enroll"
    CHECK_RESULT $? 0 0 "enroll symbol not found in libfprint"
    nm -D /usr/lib64/${libfprint}.so | grep "fp.*verify" || \
    nm -D /usr/lib/${libfprint}.so | grep "fp.*verify"
    CHECK_RESULT $? 0 0 "verify symbol not found in libfprint"
    nm -D /usr/lib64/${libfprint}.so | grep "fp.*identify" || \
    nm -D /usr/lib/${libfprint}.so | grep "fp.*identify"
    CHECK_RESULT $? 0 0 "identify symbol not found in libfprint"
    
    # Verify header file content
    grep -r "fp_print" /usr/include/${libfprint}/
    CHECK_RESULT $? 0 0 "fp_print not found in fprint.h"
    grep -r "fp.*enroll" /usr/include/${libfprint}/
    CHECK_RESULT $? 0 0 "enroll not found in fprint.h"
    grep -r "fp.*verify" /usr/include/${libfprint}/
    CHECK_RESULT $? 0 0 "verify not found in fprint.h"
    grep -r "fp.*identify" /usr/include/${libfprint}/
    CHECK_RESULT $? 0 0 "identify not found in fprint.h"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "${TEST_PROG}" "${TEST_SRC}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"