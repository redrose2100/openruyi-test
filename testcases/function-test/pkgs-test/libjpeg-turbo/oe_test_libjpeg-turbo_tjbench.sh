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
# @Desc      :   Test tjbench command - TurboJPEG benchmark
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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify tjbench help output shows usage
    tjbench -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "tjbench -h does not show usage"

    # Test decode-only benchmark on a JPEG input: -nowrite (no output files),
    # -quiet (table output). Expect throughput/frames metrics in the output.
    tjbench "${TEST_DIR}/input.jpg" -nowrite -quiet > "${TEST_DIR}/decode.txt" 2>&1
    CHECK_RESULT $? 0 0 "tjbench failed to run decode benchmark on JPEG"
    grep -Ei "Throughput|Decomp|frames|fps" "${TEST_DIR}/decode.txt"
    CHECK_RESULT $? 0 0 "tjbench decode benchmark did not produce metrics"

    # Test encode+decode benchmark on a PPM input with quality 90
    tjbench "${TEST_DIR}/input.ppm" 90 -nowrite -quiet > "${TEST_DIR}/full.txt" 2>&1
    CHECK_RESULT $? 0 0 "tjbench failed to run encode+decode benchmark on PPM"
    grep -Ei "Throughput|Comp|Decomp|frames|fps" "${TEST_DIR}/full.txt"
    CHECK_RESULT $? 0 0 "tjbench encode+decode benchmark did not produce metrics"

    # Test -subsamp 444: force 4:4:4 chroma subsampling during compression
    tjbench "${TEST_DIR}/input.ppm" 90 -subsamp 444 -nowrite -quiet > "${TEST_DIR}/subsamp.txt" 2>&1
    CHECK_RESULT $? 0 0 "tjbench -subsamp 444 failed"
    test -s "${TEST_DIR}/subsamp.txt"
    CHECK_RESULT $? 0 0 "tjbench -subsamp 444 did not produce output"

    # Test -benchtime: run a short benchmark (1 second) to verify the option
    # is accepted and the benchmark completes within a reasonable time.
    tjbench "${TEST_DIR}/input.jpg" -nowrite -quiet -benchtime 1 > "${TEST_DIR}/benchtime.txt" 2>&1
    CHECK_RESULT $? 0 0 "tjbench -benchtime 1 failed"
    test -s "${TEST_DIR}/benchtime.txt"
    CHECK_RESULT $? 0 0 "tjbench -benchtime did not produce output"

    # Test -componly: run compression-only benchmark on a PPM input
    tjbench "${TEST_DIR}/input.ppm" 90 -componly -nowrite -quiet > "${TEST_DIR}/componly.txt" 2>&1
    CHECK_RESULT $? 0 0 "tjbench -componly failed"
    grep -Ei "Throughput|Comp|frames|fps" "${TEST_DIR}/componly.txt"
    CHECK_RESULT $? 0 0 "tjbench -componly did not produce compression metrics"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
