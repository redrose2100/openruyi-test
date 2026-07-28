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
# @Desc      :   Test djpeg command - decompress JPEG images
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

    # Verify djpeg help output shows usage
    djpeg -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "djpeg -h does not show usage"

    # Test basic decoding: JPEG -> PPM, verify PPM magic number
    djpeg -outfile "${TEST_DIR}/decoded.ppm" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "djpeg failed to decode the JPEG image"
    test -s "${TEST_DIR}/decoded.ppm"
    CHECK_RESULT $? 0 0 "djpeg did not create a non-empty PPM image"
    head -c2 "${TEST_DIR}/decoded.ppm" | grep -q "P6"
    CHECK_RESULT $? 0 0 "decoded output is not a valid PPM (P6) image"

    # Test -grayscale: decode to a grayscale PPM (P5 magic)
    djpeg -grayscale -outfile "${TEST_DIR}/gray.ppm" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "djpeg -grayscale failed"
    test -s "${TEST_DIR}/gray.ppm"
    CHECK_RESULT $? 0 0 "djpeg -grayscale did not create a non-empty PPM"
    head -c2 "${TEST_DIR}/gray.ppm" | grep -q "P5"
    CHECK_RESULT $? 0 0 "decoded grayscale output is not a PGM (P5) image"

    # Test -scale 1/2: downscale the output image by half
    djpeg -scale 1/2 -outfile "${TEST_DIR}/half.ppm" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "djpeg -scale 1/2 failed"
    test -s "${TEST_DIR}/half.ppm"
    CHECK_RESULT $? 0 0 "djpeg -scale 1/2 did not create a non-empty PPM"
    # Half-scaled dimensions: 32x24 -> 16x12
    python3 - "${TEST_DIR}/half.ppm" <<'PY'
import sys
with open(sys.argv[1], "rb") as f:
    f.readline()
    w, h = map(int, f.readline().split())
    assert (w, h) == (16, 12), f"expected (16, 12), got ({w}, {h})"
PY
    CHECK_RESULT $? 0 0 "djpeg -scale 1/2 did not produce half-size image"

    # Test -bmp: decode to BMP format (magic 'BM')
    djpeg -bmp -outfile "${TEST_DIR}/out.bmp" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "djpeg -bmp failed"
    test -s "${TEST_DIR}/out.bmp"
    CHECK_RESULT $? 0 0 "djpeg -bmp did not create a non-empty BMP"
    head -c2 "${TEST_DIR}/out.bmp" | grep -q "BM"
    CHECK_RESULT $? 0 0 "decoded BMP output does not have a BM magic"

    # Test -fast: fast decompression (lower quality, valid output)
    djpeg -fast -outfile "${TEST_DIR}/fast.ppm" "${TEST_DIR}/input.jpg"
    CHECK_RESULT $? 0 0 "djpeg -fast failed"
    test -s "${TEST_DIR}/fast.ppm"
    CHECK_RESULT $? 0 0 "djpeg -fast did not create a non-empty PPM"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
