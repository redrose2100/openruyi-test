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
# @Desc      :   Test fipshmac checksum generation options and error handling
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fipscheck"
    mkdir -p /tmp/fipscheck_test/hmacdir
    printf "default checksum content\n" > /tmp/fipscheck_test/file
    printf "first multiple file\n" > /tmp/fipscheck_test/file1
    printf "second multiple file\n" > /tmp/fipscheck_test/file2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    local test_dir="/tmp/fipscheck_test"
    local original_checksum
    local modified_checksum

    cd "${test_dir}" || exit 1

    rpm -q fipscheck
    CHECK_RESULT $? 0 0 "fipscheck package is not installed"

    fipshmac > noarg.log 2>&1
    CHECK_RESULT $? 2 0 "fipshmac without arguments should return 2"
    grep -q "^usage: fipshmac" noarg.log
    CHECK_RESULT $? 0 0 "fipshmac without arguments did not print usage"

    fipshmac "${test_dir}/file"
    CHECK_RESULT $? 0 0 "fipshmac failed to create the default checksum file"
    test -f "${test_dir}/.file.hmac"
    CHECK_RESULT $? 0 0 "fipshmac did not create .file.hmac"
    grep -Eq "^[0-9a-f]{64}$" "${test_dir}/.file.hmac"
    CHECK_RESULT $? 0 0 "fipshmac created an invalid default checksum"

    original_checksum=$(cat "${test_dir}/.file.hmac")
    printf "modified checksum content\n" >> "${test_dir}/file"
    fipshmac "${test_dir}/file"
    CHECK_RESULT $? 0 0 "fipshmac failed to regenerate the checksum"
    modified_checksum=$(cat "${test_dir}/.file.hmac")
    test "${original_checksum}" != "${modified_checksum}"
    CHECK_RESULT $? 0 0 "fipshmac checksum did not change after file modification"

    fipshmac -d "${test_dir}/hmacdir" "${test_dir}/file"
    CHECK_RESULT $? 0 0 "fipshmac -d failed to create the checksum file"
    test -f "${test_dir}/hmacdir/file.hmac"
    CHECK_RESULT $? 0 0 "fipshmac -d did not create file.hmac in the target directory"
    grep -Eq "^[0-9a-f]{64}$" "${test_dir}/hmacdir/file.hmac"
    CHECK_RESULT $? 0 0 "fipshmac -d created an invalid checksum"

    fipshmac -s .custom "${test_dir}/file"
    CHECK_RESULT $? 0 0 "fipshmac -s failed to create the checksum file"
    test -f "${test_dir}/.file.custom"
    CHECK_RESULT $? 0 0 "fipshmac -s did not create .file.custom"
    grep -Eq "^[0-9a-f]{64}$" "${test_dir}/.file.custom"
    CHECK_RESULT $? 0 0 "fipshmac -s created an invalid checksum"

    fipshmac "${test_dir}/nonexistent" > nonexistent.log 2>&1
    CHECK_RESULT $? 4 0 "fipshmac should return 4 for a nonexistent file"
    grep -q "Failed to open" nonexistent.log
    CHECK_RESULT $? 0 0 "fipshmac did not report the nonexistent file"

    fipshmac "${test_dir}/file1" "${test_dir}/file2"
    CHECK_RESULT $? 0 0 "fipshmac failed to process multiple files"
    test -f "${test_dir}/.file1.hmac" && test -f "${test_dir}/.file2.hmac"
    CHECK_RESULT $? 0 0 "fipshmac did not create checksums for all input files"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/fipscheck_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
