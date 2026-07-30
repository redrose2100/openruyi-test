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
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2026-04-20
# @License   :   Mulan PSL v2
# @Desc      :   Test libjpeg-turbo package installation and integrity
# #############################################
# shellcheck disable=SC2119,SC2046

source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/libjpeg_turbo_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libjpeg-turbo libjpeg-turbo-devel gcc"
    mkdir -p "${TEST_DIR}"
    # Test libjpeg C API: compile and run a version-check program
    cat > "${TEST_DIR}/version_test.c" <<EOF
#include <stdio.h>
#include <jpeglib.h>

int main(void) {
    printf("libjpeg API version: %d\n", JPEG_LIB_VERSION);
    return 0;
}
EOF

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify library and devel packages are installed
    rpm -q libjpeg-turbo libjpeg-turbo-devel
    CHECK_RESULT $? 0 0 "libjpeg-turbo library/devel packages are not installed"

    # Cross-check version between rpm metadata and pkg-config
    rpm_version=$(rpm -q libjpeg-turbo --qf '%{VERSION}')
    CHECK_RESULT $? 0 0 "failed to get libjpeg-turbo rpm version"
    pkg_version=$(pkg-config --modversion libjpeg)
    CHECK_RESULT $? 0 0 "failed to get libjpeg pkg-config version"
    [ "${rpm_version}" = "${pkg_version}" ]
    CHECK_RESULT $? 0 0 "version mismatch: rpm=${rpm_version}, pkg-config=${pkg_version}"

    gcc -Wall -o "${TEST_DIR}/version_test" "${TEST_DIR}/version_test.c" \
        $(pkg-config --cflags --libs libjpeg)
    CHECK_RESULT $? 0 0 "failed to compile the libjpeg API program"
    "${TEST_DIR}/version_test" | grep -Eq '^libjpeg API version: [0-9]+$'
    CHECK_RESULT $? 0 0 "libjpeg API program did not run successfully"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
