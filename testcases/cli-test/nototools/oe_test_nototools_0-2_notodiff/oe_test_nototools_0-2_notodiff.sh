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
# @Date      :   2022/08/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST notodiff in nototools options
# #############################################

source "../common/common.sh"

# Preloaded data, parameter configuration
function config_params() {
    LOG_INFO "Start to config params of the case."

    TMP_DIR="$(mktemp -d -t nototools.XXXXXXXXXXXX)"
    TEST_FILE_1="font1.ttf"
    TEST_FILE_2="font2.ttf"
    MISS_LIST="glyph00569 glyph00568"

    LOG_INFO "End to config params of the case."
}

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    common_pre

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    # Compare Help Information for consistency
    notodiff -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    notocoverage --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    #Test the --before,--after parameter
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --before,--after error"
    
    #Test the -t parameter
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -t area | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: -t area error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --diff-type shape | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --diff-type shape error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -t area-shape-product | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: -t area-shape-product error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --diff-type rendered | grep -q "3 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --diff-type rendered error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -t gsub | grep -q "9 differences in GSUB rules"
    CHECK_RESULT $? 0 0 "option: -t gsub error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --diff-type gpos | grep -qE "115 differences in mark-to-mark positioning rule coverage|0 differences in mark-to-mark positioning rule values"
    CHECK_RESULT $? 0 0 "option: --diff-type gpos error"

    #Test the -m parameter
    notodiff --before test_input/test_input_1 --after test_input/test_input_2 -m *.ttf | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: -m error"
    notodiff --before test_input/test_input_1 --after test_input/test_input_2 --match *.ttf | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --match error"

    #Test the -l parameter
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -l 10 | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: -l error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --out-lines 10 | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --out-lines error"

    #Test the -w parameter
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -w ${MISS_LIST} | grep -q "15 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: -w error"
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --whitelist ${MISS_LIST} | grep -q "15 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: -w error"

    #Test the --font-size parameter
    for i in "64" "128"
    do
        notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -t rendered --font-size ${i} | grep -q "3 differences in glyph shape"
        CHECK_RESULT $? 0 0 "option: --font-size ${i} error"
    done
    
    #Test the --render-path parameter
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} -t rendered  --render-path ${TMP_DIR} | grep -q "3 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --render-path error"

    #Test the --diff-threshold parameter
    notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --diff-threshold 1 | grep -q "17 differences in glyph shape"
    CHECK_RESULT $? 0 0 "option: --diff-threshold error"

    #Test the --verbose parameter
    for i in "debug" "info" "warning" "critical" "error"
    do
        notodiff --before test_input/test_input_1/${TEST_FILE_1} --after test_input/test_input_1/${TEST_FILE_2} --verbose ${i} | grep -q "17 differences in glyph shape"
        CHECK_RESULT $? 0 0 "option: --verbose ${i} error"
    done

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