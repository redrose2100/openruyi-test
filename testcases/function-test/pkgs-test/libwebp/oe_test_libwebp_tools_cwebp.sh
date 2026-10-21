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
# @Desc      :   cwebp command test - image encoding to WebP format
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libwebp-tools"
    # Create a test PNG image using convert or create minimal valid PNG
    cat > test_input.png << 'PNGEOF'
iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==
PNGEOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

	base64 -d test_input.png > test_image.png
	CHECK_RESULT $? 0 0 "base64 decoding failed"
    rm -f test_input.png

    # Step 1: Basic cwebp encoding test
    cwebp test_image.png -o test_output.webp
    CHECK_RESULT $? 0 0 "cwebp basic encoding failed"

    # Step 2: Verify output file exists
    ls test_output.webp
    CHECK_RESULT $? 0 0 "cwebp output file not created"

    # Step 3: Test with quality parameter (-q)
    cwebp -q 80 test_image.png -o test_quality.webp
    CHECK_RESULT $? 0 0 "cwebp quality parameter test failed"

    # Step 4: Test with lossless mode (-lossless)
    cwebp -lossless test_image.png -o test_lossless.webp
    CHECK_RESULT $? 0 0 "cwebp lossless mode test failed"

    # Step 5: Test with compression level parameter (-m)
    cwebp -m 6 test_image.png -o test_compress.webp
    CHECK_RESULT $? 0 0 "cwebp compression level test failed"

    # Step 6: Test help command
    cwebp -help | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "cwebp help information not displayed"

    # Step 7: Test version command
    cwebp -version
    CHECK_RESULT $? 0 0 "cwebp version information not displayed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_image.png test_output.webp test_quality.webp test_lossless.webp test_compress.webp
    LOG_INFO "End to restore the test environment."
}

main "$@"