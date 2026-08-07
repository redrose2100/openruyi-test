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
# @Desc      :   Verify pngfix tool (part 1)
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
    rpm -q libpng-tools | grep libpng-tools
    CHECK_RESULT $? 0 0 "libpng-tools package not installed"
    test -f /usr/bin/pngfix
    CHECK_RESULT $? 0 0 "pngfix binary missing"
    pngfix --help 2>&1 | grep Usage
    CHECK_RESULT $? 0 0 "pngfix --help failed"
    g++ -std=c++11 "./common/libpng_test.c" -o "./libpng_test" -lpng -lz
    CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
    ./libpng_test create_rgb
    CHECK_RESULT $? 0 0 "Failed to generate test PNG"
    cp /tmp/libpng_test_rgb.png ./test_input.png
    # pngfix default
    pngfix ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix default check failed"
    # pngfix --out
    pngfix --out=./test_out.png ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --out failed"
    test -s ./test_out.png && file ./test_out.png | grep PNG
    CHECK_RESULT $? 0 0 "pngfix --out output invalid"
    # pngfix --optimize --out
    pngfix --optimize --out=./test_opt.png ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --optimize failed"
    test -s ./test_opt.png && file ./test_opt.png | grep PNG
    CHECK_RESULT $? 0 0 "pngfix --optimize output invalid"
    # pngfix --strip=all --out
    pngfix --strip=all --out=./test_strip.png ./test_input.png | grep test_input
    CHECK_RESULT $? 0 0 "pngfix --strip=all failed"
    test -s ./test_strip.png && file ./test_strip.png | grep PNG
    CHECK_RESULT $? 0 0 "pngfix --strip=all output invalid"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -rf ./libpng_test ./*.png* ./*_fixed ./gen_itxt
    rm -f /tmp/libpng_test_*.png /tmp/libpng_test_bad.png
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

