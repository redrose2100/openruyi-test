#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/08/27
# @License   :   Mulan PSL v2
# @Desc      :   TEST create_image.py in nototools options
# #############################################

source "../common/common.sh"

# Preloaded data, parameter configuration
function config_params() {
    LOG_INFO "Start to config params of the case."

    TMP_DIR="$(mktemp -d -t nototools.XXXXXXXXXXXX)"

    LOG_INFO "End to config params of the case."
}

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    common_pre
    mkdir -p ${TMP_DIR}/test
    cp -rf ./* ${TMP_DIR}

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
# create_image.py has a lot of method name changes due to python version changes, so we need to skip some parameter tests.
# Specifically involved are these instructions：--test、--codes、--text、--out、-f、-b、-i、-st、s、-l、t、mh、hm
function run_test() {
    LOG_INFO "Start to run test."

    # Compare Help Information for consistency
    create_image.py -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    create_image.py --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    cd ${TMP_DIR}/test

    #Test the --test parameter
    create_image.py --test && test -f en_latn_udhr.svg
    CHECK_RESULT $? 0 0 "option: --test error"

    #Test the --codes parameter
    create_image.py --codes 1234 -f NotoNaskhArabic -b bold -i italic -st semi-condensed -s 16 -l ar -t png && \
        test -f NotoNaskhArabic_1234_bold_italic_semi-condensed_16_ar.png
    CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNaskhArabic -b bold -i italic -st semi-condensed -s 16 -l ar -t png error"
    create_image.py --codes 1234 -f NotoNasJPArabic -b heavy -i oblique -st ultra-expanded -s 8 -l JP -t svg && \
        test -f NotoNasJPArabic_1234_heavy_oblique_ultra-expanded_8_JP.svg
    CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNasJPArabic -b heavy -i oblique -st ultra-expanded -s 8 -l JP -t svg error"
    create_image.py --codes 1234 -f NotoNas -b normal -i normal -st semi-expanded -s 8 -l mn -t png && \
        test -f NotoNas_1234_normal_normal_semi-expanded_8_mn.png
    CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNas -b normal -i normal -st semi-expanded -s 8 -l mn -t png error"
    create_image.py --codes 1234 -f NotoNas -b bold -i italic -st extra-expanded -s 16 -l ar -t svg && \
        test -f NotoNas_1234_bold_italic_extra-expanded_16_ar.svg
    CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNas -b bold -i italic -st extra-expanded -s 16 -l ar -t svg error"
    create_image.py --codes 1234 --font NotoNaskhArabic --bold bold --italic italic --stretch semi-condensed --size 16 --lang ar --type png && \
        test -f NotoNaskhArabic_1234_bold_italic_semi-condensed_16_ar.png
    CHECK_RESULT $? 0 0 "option: --codes 1234 --font NotoNaskhArabic --bold bold --italic italic --stretch semi-condensed --size 16 --lang ar --type png error"

    # Test the --text parameter
    create_image.py --text 1234 -f NotoNaskhArabic -b ultralight -i italic -st ultra-condensed -s 16 -l ar -t png && \
        test -f NotoNaskhArabic_31_32_33_34_ultralight_italic_ultra-condensed_16_ar.png
    CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNaskhArabic -b ultralight -i italic -st ultra-condensed -s 16 -l ar -t png error"
    create_image.py --text 1234 -f NotoNasJPArabic -b light -i oblique -st extra-condensed -s 8 -l JP -t svg && \
        test -f NotoNasJPArabic_31_32_33_34_light_oblique_extra-condensed_8_JP.svg
    CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNasJPArabic -b light -i oblique -st extra-condensed -s 8 -l JP -t svg error"
    create_image.py --text 1234 -f NotoNas -b normal -i normal -st condensed -s 8 -l mn -t png -mh -2 -hm 16 && \
        test -f NotoNas_31_32_33_34_normal_normal_condensed_8_mn.png
    CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNas -b normal -i normal -st condensed -s 8 -l mn -t png -mh -2 -hm 16 error"
    create_image.py --text 1234 -f NotoNas -b bold -i italic -st normal -s 16 -l ar -t svg -mh -2 -hm 16 && \
        test -f NotoNas_31_32_33_34_bold_italic_normal_16_ar.svg
    CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNas -b bold -i italic -st normal -s 16 -l ar -t svg -mh -2 -hm 16 error"
    create_image.py --text 1234 --font NotoNas --bold bold --italic italic --stretch normal --size 16 --lang ar --type svg --maxheight -2 --horiz_margin 16 && \
        test -f NotoNas_31_32_33_34_bold_italic_normal_16_ar.svg
    CHECK_RESULT $? 0 0 "option: --text 1234 --font NotoNas --bold bold --italic italic --stretch normal --size 16 --lang ar --type svg --maxheight -2 --horiz_margin 16 error"

    # Test the --out parameter
    create_image.py --out "output.svg" --text "123" && \
        test -f output.svg
    CHECK_RESULT $? 0 0 "option: --out error"
    
    cd - > /dev/null

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ${TMP_DIR}
    common_post

    LOG_INFO "End to restore the test environment."
}

main "$@"