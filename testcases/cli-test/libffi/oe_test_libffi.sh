#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/30
# @License   :   Mulan PSL v2
# @Desc      :   Test libffi C API calls
# #############################################
# shellcheck disable=SC2119,SC2046
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libffi libffi-devel gcc"
    mkdir -p /tmp/libffi_test
    # Generate the libffi C API test program
    cat > /tmp/libffi_test/ffi_call.c <<'EOF'
#include <ffi.h>
#include <stdio.h>

static int add_ints(int left, int right)
{
    return left + right;
}

int main(void)
{
    ffi_cif cif;
    ffi_type *argument_types[2] = {&ffi_type_sint, &ffi_type_sint};
    void *arguments[2];
    int left = 19;
    int right = 23;
    int result = 0;

    arguments[0] = &left;
    arguments[1] = &right;
    if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 2, &ffi_type_sint,
                     argument_types) != FFI_OK) {
        return 1;
    }
    ffi_call(&cif, FFI_FN(add_ints), &result, arguments);
    printf("FFI_RESULT %d\n", result);
    return result == 42 ? 0 : 1;
}
EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify library and devel packages are installed
    rpm -q libffi libffi-devel
    CHECK_RESULT $? 0 0 "libffi packages are not installed"

    # Cross-check version between rpm metadata and pkg-config
    rpm_version=$(rpm -q libffi --qf '%{VERSION}')
    CHECK_RESULT $? 0 0 "failed to get libffi rpm version"
    pkg_version=$(pkg-config --modversion libffi)
    CHECK_RESULT $? 0 0 "failed to get libffi pkg-config version"
    [ "${rpm_version}" = "${pkg_version}" ]
    CHECK_RESULT $? 0 0 "version mismatch: rpm=${rpm_version}, pkg-config=${pkg_version}"

    # Test libffi C API: compile and run a basic ffi_call program
    pkgconf_flags=$(pkg-config --cflags --libs libffi)
    gcc -Wall -Wextra -o /tmp/libffi_test/ffi_call \
        /tmp/libffi_test/ffi_call.c ${pkgconf_flags}
    CHECK_RESULT $? 0 0 "failed to compile the libffi API test program"
    /tmp/libffi_test/ffi_call | grep -q "^FFI_RESULT 42$"
    CHECK_RESULT $? 0 0 "libffi ffi_call did not return the expected result"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/libffi_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
