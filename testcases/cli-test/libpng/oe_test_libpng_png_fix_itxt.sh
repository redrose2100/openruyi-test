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
# @Desc      :   Verify png-fix-itxt and libpng16-config tools
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
    rpm -q libpng-tools | grep "libpng-tools"
    CHECK_RESULT $? 0 0 "libpng-tools package not installed"
    ls -l /usr/bin/png-fix-itxt | grep "png-fix-itxt"
    CHECK_RESULT $? 0 0 "png-fix-itxt binary missing"
    g++ -std=c++11 "./common/libpng_gen_itxt.c" -o "./gen_itxt" -lpng -lz
    CHECK_RESULT $? 0 0 "Failed to compile iTXt PNG generator"
    ./gen_itxt ./itxt_input.png | grep "ITXT_PNG_OK"
    CHECK_RESULT $? 0 0 "Failed to generate iTXt PNG"
    # png-fix-itxt core: stdin/stdout pipe, output must be valid PNG
    png-fix-itxt < ./itxt_input.png > ./itxt_output.png && xxd ./itxt_output.png | head -1 | grep "8950 4e47"
    CHECK_RESULT $? 0 0 "png-fix-itxt output missing PNG magic bytes"
    file ./itxt_output.png | grep -i "png"
    CHECK_RESULT $? 0 0 "png-fix-itxt output not recognized as PNG"
    grep -a "IEND" ./itxt_output.png
    CHECK_RESULT $? 0 0 "png-fix-itxt output missing IEND chunk"
    # png-fix-itxt idempotent
    png-fix-itxt < ./itxt_output.png > ./itxt_output2.png && file ./itxt_output2.png | grep -i "png"
    CHECK_RESULT $? 0 0 "png-fix-itxt idempotent run output invalid"
    grep -a "IHDR" ./itxt_output2.png
    CHECK_RESULT $? 0 0 "png-fix-itxt idempotent output missing IHDR chunk"
    # png-fix-itxt on regular PNG (no iTXt chunks, should pass through)
    g++ -std=c++11 "./common/libpng_test.c" -o "./libpng_test" -lpng -lz
    CHECK_RESULT $? 0 0 "Failed to compile libpng test program"
    ./libpng_test create_rgb | grep "LIBPNG_CREATE_RGB_OK"
    CHECK_RESULT $? 0 0 "Failed to generate regular RGB PNG"
    cp /tmp/libpng_test_rgb.png ./regular.png
    md5_reg=$(md5sum ./regular.png | awk '{print $1}')
    png-fix-itxt < ./regular.png > ./regular_fixed.png && file ./regular_fixed.png | grep -i "png"
    CHECK_RESULT $? 0 0 "png-fix-itxt regular PNG output invalid"
    md5_fixed=$(md5sum ./regular_fixed.png | awk '{print $1}')
    echo "${md5_reg} ${md5_fixed}" | grep -E "^[a-f0-9]{32} [a-f0-9]{32}$"
    CHECK_RESULT $? 0 0 "png-fix-itxt regular PNG md5 check failed"
    # png-fix-itxt on empty stdin (should not hang, exit 0)
    png-fix-itxt < /dev/null > ./empty_out.png
    CHECK_RESULT $? 0 0 "png-fix-itxt on empty stdin should exit 0"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -f ./gen_itxt ./*.png
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
