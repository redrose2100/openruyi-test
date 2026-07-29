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
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-07-27
# @License   :   Mulan PSL v2
# @Desc      :   dwebp command test - WebP decoding to other formats
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libwebp-tools"
    # Create a test PNG image and convert to WebP
    cat > test_input.png << 'PNGEOF'
iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==
PNGEOF
    base64 -d test_input.png > test_image.png
    rm -f test_input.png
    cwebp test_image.png -o test_input.webp
    CHECK_RESULT $? 0 0 "Failed to create test WebP file"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Basic dwebp decoding to PNG
    dwebp test_input.webp -o test_output.png
    CHECK_RESULT $? 0 0 "dwebp basic decoding to PNG failed"

    # Step 2: Verify output file exists
    ls test_output.png
    CHECK_RESULT $? 0 0 "dwebp output PNG file not created"

    # Step 3: Test decoding to PPM format (-ppm)
    dwebp test_input.webp -ppm -o test_output.ppm
    CHECK_RESULT $? 0 0 "dwebp decoding to PPM failed"

    # Step 4: Test decoding to PGM format (-pgm)
    dwebp test_input.webp -pgm -o test_output.pgm
    CHECK_RESULT $? 0 0 "dwebp decoding to PGM failed"

    # Step 5: Test decoding to PAM format (-pam)
    dwebp test_input.webp -pam -o test_output.pam
    CHECK_RESULT $? 0 0 "dwebp decoding to PAM failed"

    # Step 6: Test help command
    dwebp -help | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "dwebp help information not displayed"

    # Step 7: Test version command
    dwebp -version
    CHECK_RESULT $? 0 0 "dwebp version information not displayed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_image.png test_input.webp test_output.png test_output.ppm test_output.pgm test_output.pam
    LOG_INFO "End to restore the test environment."
}

main "$@"