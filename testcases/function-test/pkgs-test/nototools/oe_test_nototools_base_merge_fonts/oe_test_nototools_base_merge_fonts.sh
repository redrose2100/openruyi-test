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
# @Date      :   2022/08/31
# @License   :   Mulan PSL v2
# @Desc      :   TEST merge_fonts in nototools
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

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    # Compare Help Information for consistency
    merge_fonts.py -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    merge_fonts.py --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    # Test the -d -o parameter
    merge_fonts.py -d ./ -o ${TMP_DIR}/merged.ttf && \
        fc-scan ${TMP_DIR}/merged.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: -d -o error"
    rm -rf ${TMP_DIR}/*
    # Test the -d -o -v parameter
    merge_fonts.py -d ./ -o ${TMP_DIR}/merged.ttf -v 2>&1 && \
        fc-scan ${TMP_DIR}/merged.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: -d -o -v error"
    rm -rf ${TMP_DIR}/*
    # Test the --directory --output --verbose parameter
    merge_fonts.py --directory ./ --output ${TMP_DIR}/merged.ttf --verbose 2>&1 && \
        fc-scan ${TMP_DIR}/merged.ttf | grep -q "Noto Sans"
    CHECK_RESULT $? 0 0 "option: --directory --output --verbose error"
    rm -rf ${TMP_DIR}/*
    
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