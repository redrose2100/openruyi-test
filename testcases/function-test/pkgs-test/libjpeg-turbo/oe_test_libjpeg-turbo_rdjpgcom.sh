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
# @Date      :   2026/07/21
# @License   :   Mulan PSL v2
# @Desc      :   Test rdjpgcom command - read JPEG comments
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/function-test/pkgs-test/libjpeg-turbo/common/gen_image.sh

TEST_DIR="/tmp/libjpeg_turbo_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libjpeg-turbo-utils"
    mkdir -p "${TEST_DIR}"
    gen_ppm_image "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
    gen_jpeg_image "${TEST_DIR}/input.ppm" "${TEST_DIR}/input.jpg" 90
    CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
    # Prepare a JPEG with a known comment for read-back tests
    wrjpgcom -comment "Mugen test comment" "${TEST_DIR}/input.jpg" > "${TEST_DIR}/commented.jpg"
    CHECK_RESULT $? 0 0 "failed to prepare a JPEG with a comment"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify rdjpgcom help output shows usage
    rdjpgcom -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "rdjpgcom -h does not show usage"

    # Test basic read: extract the comment text from a JPEG
    rdjpgcom "${TEST_DIR}/commented.jpg" | grep -q "Mugen test comment"
    CHECK_RESULT $? 0 0 "rdjpgcom did not return the expected comment text"

    # Test reading from stdin: rdjpgcom reads stdin by default when no
    # inputfile argument is provided. Do NOT pass "-" as an argument —
    # rdjpgcom treats it as an unknown switch.
    rdjpgcom < "${TEST_DIR}/commented.jpg" | grep -q "Mugen test comment"
    CHECK_RESULT $? 0 0 "rdjpgcom stdin read did not return the expected comment"

    # Test -raw: output raw comment bytes (no newline translation)
    rdjpgcom -raw "${TEST_DIR}/commented.jpg" | grep -q "Mugen test comment"
    CHECK_RESULT $? 0 0 "rdjpgcom -raw did not return the expected comment"

    # Test reading a JPEG with no comment: exit code 0, empty output
    empty_out=$(rdjpgcom "${TEST_DIR}/input.jpg")
    CHECK_RESULT $? 0 0 "rdjpgcom failed on a JPEG with no comment"
    test -z "$empty_out"
    CHECK_RESULT $? 0 0 "rdjpgcom on a comment-less JPEG should produce empty output"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
