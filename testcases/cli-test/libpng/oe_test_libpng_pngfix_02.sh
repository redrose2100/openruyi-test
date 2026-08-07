#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/08/05
# @License   :   Mulan PSL v2
# @Desc      :   Verify pngfix tool (part 2)
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libpng-tools libpng-devel gcc-c++"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    g++ -std=c++11 "./common/libpng_test.c" -o "./libpng_test" -lpng -lz
    CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
    ./libpng_test create_rgb
    CHECK_RESULT $? 0 0 "Failed to generate test PNG"
    cp /tmp/libpng_test_rgb.png ./test_input.png
    # pngfix --max
    pngfix --max=65536 --out=./test_max.png ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --max failed"
    test -s ./test_max.png && file ./test_max.png | grep PNG
    CHECK_RESULT $? 0 0 "pngfix --max output invalid"
    # pngfix --quiet
    pngfix --quiet ./test_input.png
    CHECK_RESULT $? 0 0 "pngfix --quiet failed"
    # pngfix --errors
    pngfix --errors ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --errors failed"
    # pngfix --warnings
    pngfix --warnings ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --warnings failed"
    # pngfix --strip=crc --out
    pngfix --strip=crc --out=./test_crc.png ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --strip=crc failed"
    test -s ./test_crc.png && file ./test_crc.png | grep PNG
    CHECK_RESULT $? 0 0 "pngfix --strip=crc output invalid"
    # pngfix invalid argument: usage
    pngfix --invalid-arg 2>&1 | grep -i usage
    CHECK_RESULT $? 0 0 "pngfix invalid arg should show usage"
    # pngfix invalid argument: exit 255
    pngfix --invalid-arg 2>&1
    CHECK_RESULT $? 255 0 "pngfix invalid arg should exit 255"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -f ./libpng_test ./*.png* ./*_fixed
    rm -f /tmp/libpng_test_rgb.png /tmp/libpng_test_gray.png /tmp/libpng_test_rgba.png
    rm -f /tmp/libpng_test_palette.png /tmp/libpng_test_compression.png /tmp/libpng_test_bad.png
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

