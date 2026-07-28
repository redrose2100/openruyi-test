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
# @Desc      :   Test wrjpgcom command - write JPEG comments
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

    # Verify wrjpgcom help output shows usage
    wrjpgcom -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "wrjpgcom -h does not show usage"

    # Test -comment: write a comment to a new JPEG (stdout), verify with rdjpgcom
    wrjpgcom -comment "Mugen libjpeg-turbo test" "${TEST_DIR}/input.jpg" > "${TEST_DIR}/commented.jpg"
    CHECK_RESULT $? 0 0 "wrjpgcom -comment failed to write a JPEG comment"
    test -s "${TEST_DIR}/commented.jpg"
    CHECK_RESULT $? 0 0 "wrjpgcom did not create a non-empty JPEG"
    rdjpgcom "${TEST_DIR}/commented.jpg" | grep -q "Mugen libjpeg-turbo test"
    CHECK_RESULT $? 0 0 "rdjpgcom could not read back the -comment text"

    # Test comment text from stdin (no -comment/-cfile option): wrjpgcom
    # reads comment text from stdin when neither is given
    echo "Stdin comment text" | wrjpgcom "${TEST_DIR}/input.jpg" > "${TEST_DIR}/stdin.jpg"
    CHECK_RESULT $? 0 0 "wrjpgcom stdin comment failed"
    rdjpgcom "${TEST_DIR}/stdin.jpg" | grep -q "Stdin comment text"
    CHECK_RESULT $? 0 0 "rdjpgcom could not read back the stdin comment text"

    # Test -cfile: read comment text from a file
    echo "Comment from a file" > "${TEST_DIR}/comment.txt"
    wrjpgcom -cfile "${TEST_DIR}/comment.txt" "${TEST_DIR}/input.jpg" > "${TEST_DIR}/cfile.jpg"
    CHECK_RESULT $? 0 0 "wrjpgcom -cfile failed"
    rdjpgcom "${TEST_DIR}/cfile.jpg" | grep -q "Comment from a file"
    CHECK_RESULT $? 0 0 "rdjpgcom could not read back the -cfile comment text"

    # Test -replace: replace existing comment instead of appending
    wrjpgcom -comment "First comment" "${TEST_DIR}/input.jpg" > "${TEST_DIR}/two_steps.jpg"
    CHECK_RESULT $? 0 0 "wrjpgcom first -comment failed"
    wrjpgcom -replace -comment "Replaced comment" "${TEST_DIR}/two_steps.jpg" > "${TEST_DIR}/replaced.jpg"
    CHECK_RESULT $? 0 0 "wrjpgcom -replace failed"
    # After -replace, only the new comment should be present
    rdjpgcom "${TEST_DIR}/replaced.jpg" | grep -q "Replaced comment"
    CHECK_RESULT $? 0 0 "rdjpgcom could not read back the replaced comment"
    ! rdjpgcom "${TEST_DIR}/replaced.jpg" | grep -q "First comment"
    CHECK_RESULT $? 0 0 "wrjpgcom -replace should have removed the old comment"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
