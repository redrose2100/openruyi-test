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
# @Desc      :   Test jpegtran command - lossless JPEG transformation
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/libjpeg-turbo/common/gen_image.sh

TEST_DIR="/tmp/libjpeg_turbo_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libjpeg-turbo-utils"
    mkdir -p "${TEST_DIR}"
    gen_ppm_image "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "failed to generate the PPM test image"
    gen_jpeg_image "${TEST_DIR}/input.ppm" "${TEST_DIR}/input.jpg" 90
    CHECK_RESULT $? 0 0 "failed to encode the test JPEG image"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify jpegtran help output shows usage
    jpegtran -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "jpegtran -h does not show usage"

    # Test basic transformation: copy input to a new JPEG, verify SOI marker
    jpegtran -outfile "${TEST_DIR}/copy.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran failed to copy the JPEG image"
    test -s "${TEST_DIR}/copy.jpg"
    CHECK_RESULT $? 0 0 "jpegtran did not create a non-empty JPEG"
    od -An -tx1 -N2 "${TEST_DIR}/copy.jpg" | tr -d ' \n' | grep -q '^ffd8'
    CHECK_RESULT $? 0 0 "jpegtran output does not have a JPEG SOI marker"

    # Test -copy none: strip all non-essential markers (smaller output)
    jpegtran -copy none -outfile "${TEST_DIR}/stripped.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -copy none failed"
    test -s "${TEST_DIR}/stripped.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -copy none did not create a non-empty JPEG"

    # Test -optimize: optimize Huffman tables
    jpegtran -optimize -outfile "${TEST_DIR}/opt.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -optimize failed"
    test -s "${TEST_DIR}/opt.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -optimize did not create a non-empty JPEG"

    # Test -progressive: convert to progressive JPEG
    jpegtran -progressive -outfile "${TEST_DIR}/prog.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -progressive failed"
    test -s "${TEST_DIR}/prog.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -progressive did not create a non-empty JPEG"

    # Test -grayscale: convert to grayscale JPEG (fewer bytes than color)
    jpegtran -grayscale -outfile "${TEST_DIR}/gray.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -grayscale failed"
    test -s "${TEST_DIR}/gray.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -grayscale did not create a non-empty JPEG"
    test "$(stat -c%s "${TEST_DIR}/gray.jpg")" -lt "$(stat -c%s "${TEST_DIR}/copy.jpg")"
    CHECK_RESULT $? 0 0 "grayscale JPEG should be smaller than the color JPEG"

    # Test -rotate 90: lossless 90-degree rotation, swaps dimensions
    jpegtran -rotate 90 -outfile "${TEST_DIR}/rot90.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -rotate 90 failed"
    test -s "${TEST_DIR}/rot90.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -rotate 90 did not create a non-empty JPEG"

    # Test -flip horizontal: lossless horizontal mirror
    jpegtran -flip horizontal -outfile "${TEST_DIR}/flip.jpg" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -flip horizontal failed"
    test -s "${TEST_DIR}/flip.jpg"
    CHECK_RESULT $? 0 0 "jpegtran -flip horizontal did not create a non-empty JPEG"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
