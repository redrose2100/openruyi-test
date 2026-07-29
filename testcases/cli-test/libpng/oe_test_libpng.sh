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
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/24
# @License   :   Mulan PSL v2
# @Desc      :   Verify libpng package and basic image encode/decode functions
# ############################################
 # shellcheck disable=SC2119
 
source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libpng-devel gcc-c++"
    TEST_SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)/common"
    export TEST_SRC_DIR
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q libpng | grep "libpng"
    CHECK_RESULT $? 0 0 "libpng package not installed"
    rpm -V libpng
    CHECK_RESULT $? 0 0 "libpng package verification failed"
    test -f /usr/include/png.h
    CHECK_RESULT $? 0 0 "libpng header file png.h missing"
    rpm -ql libpng | grep -E "\.(so|so\.[0-9]+)$"
    CHECK_RESULT $? 0 0 "libpng shared library missing"
    g++ -std=c++11 "${TEST_SRC_DIR}/libpng_test.c" -o "./libpng_test" -lpng -lz
    CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
    ./libpng_test version | grep "LIBPNG_VERSION_OK"
    CHECK_RESULT $? 0 0 "libpng version test failed"
    ./libpng_test create_rgb | grep "LIBPNG_CREATE_RGB_OK"
    CHECK_RESULT $? 0 0 "libpng create RGB image failed"
    ./libpng_test create_gray | grep "LIBPNG_CREATE_GRAY_OK"
    CHECK_RESULT $? 0 0 "libpng create grayscale image failed"
    ./libpng_test create_rgba | grep "LIBPNG_CREATE_RGBA_OK"
    CHECK_RESULT $? 0 0 "libpng create RGBA image failed"
    ./libpng_test create_palette | grep "LIBPNG_CREATE_PALETTE_OK"
    CHECK_RESULT $? 0 0 "libpng create palette image failed"
    ./libpng_test read_image | grep "LIBPNG_READ_OK"
    CHECK_RESULT $? 0 0 "libpng read image failed"
    ./libpng_test compression | grep "LIBPNG_COMPRESSION_OK"
    CHECK_RESULT $? 0 0 "libpng compression test failed"
    ./libpng_test bad_file | grep "LIBPNG_BAD_FILE_OK"
    CHECK_RESULT $? 0 0 "libpng bad file handling test failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -f ./libpng_test
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
