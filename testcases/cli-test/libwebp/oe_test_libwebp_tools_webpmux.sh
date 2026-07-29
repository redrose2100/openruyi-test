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
# @Desc      :   webpmux command test - WebP container manipulation
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libwebp-tools"
    # Create test PNG images and convert to WebP
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

    # Step 1: Basic webpmux test - get info
    webpmux -info test_input.webp
    CHECK_RESULT $? 0 0 "webpmux info command failed"

    # Step 2: Test help command
    webpmux -help | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "webpmux help information not displayed"

    # Step 3: Test version command
    webpmux -version
    CHECK_RESULT $? 0 0 "webpmux version information not displayed"

    # Step 4: Test adding ICC profile placeholder
    echo "Test ICC profile data" > icc_profile.bin
    webpmux -set icc icc_profile.bin test_input.webp -o test_icc.webp
    CHECK_RESULT $? 0 0 "webpmux set ICC profile failed"

    # Step 5: Test getting ICC profile from WebP file
    webpmux -get icc test_icc.webp -o extracted_icc.bin
    CHECK_RESULT $? 0 0 "webpmux get ICC profile failed"

    # Step 6: Verify extracted ICC profile exists
    ls extracted_icc.bin
    CHECK_RESULT $? 0 0 "webpmux extracted ICC profile file not created"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_image.png test_input.webp test_icc.webp icc_profile.bin extracted_icc.bin
    LOG_INFO "End to restore the test environment."
}

main "$@"