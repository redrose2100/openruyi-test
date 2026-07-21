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
# @Date      :   2026/07/20
# @License   :   Mulan PSL v2
# @Desc      :   Test fipscheck file integrity verification in FIPS and non-FIPS modes
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fipscheck"
    mkdir -p /tmp/fipscheck_test
    printf "first file content\n" > /tmp/fipscheck_test/file1
    printf "second file content\n" > /tmp/fipscheck_test/file2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local test_dir="/tmp/fipscheck_test"
    local fips_mode

    rpm -q fipscheck
    CHECK_RESULT $? 0 0 "fipscheck package is not installed"


    test -x /usr/bin/fipscheck && test -x /usr/bin/fipshmac && test -f /usr/lib64/libfipscheck.so.1
    CHECK_RESULT $? 0 0 "fipscheck package is missing required binaries or library"

    ldd /usr/bin/fipscheck /usr/bin/fipshmac /usr/lib64/libfipscheck.so.1 2>&1 | grep -q "not found"
    CHECK_RESULT $? 1 0 "fipscheck has unresolved runtime dependencies"

    grep -Eq "^[0-9a-f]{64}$" /usr/lib64/fipscheck/fipscheck.hmac && \
        grep -Eq "^[0-9a-f]{64}$" /usr/lib64/fipscheck/libfipscheck.so.1.hmac
    CHECK_RESULT $? 0 0 "fipscheck package contains an invalid HMAC file"

    fipscheck > "${test_dir}/noarg.log" 2>&1
    CHECK_RESULT $? 0 1 "fipscheck without arguments should fail"
    grep -q "^usage: fipscheck" "${test_dir}/noarg.log"
    CHECK_RESULT $? 0 0 "fipscheck without arguments did not print usage"

    fipshmac "${test_dir}/file1" "${test_dir}/file2"
    CHECK_RESULT $? 0 0 "fipshmac failed to prepare checksum files"
    test -f "${test_dir}/.file1.hmac" && test -f "${test_dir}/.file2.hmac"
    CHECK_RESULT $? 0 0 "fipshmac did not create checksum files for verification"

    fipshmac -s .custom "${test_dir}/file1"
    CHECK_RESULT $? 0 0 "fipshmac failed to prepare the custom checksum file"

    fips_mode=$(cat /proc/sys/crypto/fips_enabled 2>/dev/null || echo 0)

    if [ "${fips_mode}" -eq 0 ]; then
        fipscheck "${test_dir}/file1"
        CHECK_RESULT $? 0 1 "fipscheck should fail when FIPS mode is unavailable"
    else
        fipscheck "${test_dir}/file1"
        CHECK_RESULT $? 0 0 "fipscheck failed to verify the default checksum"
    fi

    if [ "${fips_mode}" -eq 0 ]; then
        fipscheck -s .custom "${test_dir}/file1"
        CHECK_RESULT $? 0 1 "fipscheck with a custom suffix should fail when FIPS mode is unavailable"
    else
        fipscheck -s .custom "${test_dir}/file1"
        CHECK_RESULT $? 0 0 "fipscheck failed to verify the custom checksum"
    fi

    if [ "${fips_mode}" -eq 0 ]; then
        fipscheck "${test_dir}/file1" "${test_dir}/file2"
        CHECK_RESULT $? 0 1 "fipscheck with multiple files should fail when FIPS mode is unavailable"
    else
        fipscheck "${test_dir}/file1" "${test_dir}/file2"
        CHECK_RESULT $? 0 0 "fipscheck failed to verify multiple files"
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/fipscheck_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
