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
# @Desc      :   gif2webp command test - GIF to WebP conversion
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libwebp-tools"
    # Create a minimal valid GIF file
    cat > test_input.gif << 'GIFEOF'
R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7
GIFEOF
    base64 -d test_input.gif > test_image.gif
    rm -f test_input.gif
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Basic gif2webp conversion test
    gif2webp test_image.gif -o test_output.webp
    CHECK_RESULT $? 0 0 "gif2webp basic conversion failed"

    # Step 2: Verify output file exists
    ls test_output.webp
    CHECK_RESULT $? 0 0 "gif2webp output file not created"

    # Step 3: Test with quality parameter (-q)
    gif2webp -q 80 test_image.gif -o test_quality.webp
    CHECK_RESULT $? 0 0 "gif2webp quality parameter test failed"

    # Step 4: Test with mixed mode (-mixed)
    gif2webp -mixed test_image.gif -o test_mixed.webp
    CHECK_RESULT $? 0 0 "gif2webp mixed mode test failed"

    # Step 5: Test help command
    gif2webp -help | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "gif2webp help information not displayed"

    # Step 6: Test version command
    gif2webp -version
    CHECK_RESULT $? 0 0 "gif2webp version information not displayed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -f test_image.gif test_output.webp test_quality.webp test_mixed.webp
    LOG_INFO "End to restore the test environment."
}

main "$@"