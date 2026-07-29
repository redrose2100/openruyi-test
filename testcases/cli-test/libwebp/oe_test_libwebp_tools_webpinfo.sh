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
# @Desc      :   webpinfo command test - WebP file information display
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

    # Step 1: Basic webpinfo test
    webpinfo test_input.webp
    CHECK_RESULT $? 0 0 "webpinfo basic test failed"

    # Step 2: Test with verbose mode (-verbose)
    webpinfo -verbose test_input.webp
    CHECK_RESULT $? 0 0 "webpinfo verbose mode test failed"

    # Step 3: Test with summary mode (-summary)
    webpinfo -summary test_input.webp
    CHECK_RESULT $? 0 0 "webpinfo summary mode test failed"

    # Step 4: Verify webpinfo output contains WebP header info
    webpinfo test_input.webp | grep -i "Width\|Height\|Format"
    CHECK_RESULT $? 0 0 "webpinfo output does not contain expected information"

    # Step 5: Test help command
    webpinfo -help | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "webpinfo help information not displayed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_image.png test_input.webp
    LOG_INFO "End to restore the test environment."
}

main "$@"