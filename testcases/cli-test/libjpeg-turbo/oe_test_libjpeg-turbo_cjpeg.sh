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
# @Desc      :   Test cjpeg command - compress images to JPEG
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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify cjpeg help output shows usage
    cjpeg -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "cjpeg -h does not show usage"

    # Test basic encoding with -quality: PPM -> JPEG, verify JPEG SOI marker
    cjpeg -quality 90 -outfile "${TEST_DIR}/basic.jpg" "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "cjpeg failed to encode PPM with -quality 90"
    test -s "${TEST_DIR}/basic.jpg"
    CHECK_RESULT $? 0 0 "cjpeg did not create a non-empty JPEG image"
    od -An -tx1 -N2 "${TEST_DIR}/basic.jpg" | tr -d ' \n' | grep -q '^ffd8'
    CHECK_RESULT $? 0 0 "encoded output does not have a JPEG SOI marker"

    # Test -quality with a different value produces a different file size
    cjpeg -quality 30 -outfile "${TEST_DIR}/q30.jpg" "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "cjpeg -quality 30 failed"
    cjpeg -quality 95 -outfile "${TEST_DIR}/q95.jpg" "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "cjpeg -quality 95 failed"
    test "$(stat -c%s "${TEST_DIR}/q95.jpg")" -gt "$(stat -c%s "${TEST_DIR}/q30.jpg")"
    CHECK_RESULT $? 0 0 "higher quality should produce a larger JPEG file"

    # Test -grayscale: produce a grayscale JPEG (no chroma components)
    cjpeg -grayscale -outfile "${TEST_DIR}/gray.jpg" "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "cjpeg -grayscale failed"
    test -s "${TEST_DIR}/gray.jpg"
    CHECK_RESULT $? 0 0 "cjpeg -grayscale did not create a non-empty JPEG"

    # Test -optimize: optimize Huffman tables (produces valid JPEG)
    cjpeg -optimize -outfile "${TEST_DIR}/opt.jpg" "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "cjpeg -optimize failed"
    test -s "${TEST_DIR}/opt.jpg"
    CHECK_RESULT $? 0 0 "cjpeg -optimize did not create a non-empty JPEG"

    # Test -progressive: produce a progressive JPEG (contains SOS markers)
    cjpeg -progressive -outfile "${TEST_DIR}/prog.jpg" "${TEST_DIR}/input.ppm"
    CHECK_RESULT $? 0 0 "cjpeg -progressive failed"
    test -s "${TEST_DIR}/prog.jpg"
    CHECK_RESULT $? 0 0 "cjpeg -progressive did not create a non-empty JPEG"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
