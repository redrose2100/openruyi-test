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
# @Author    :   songfurong
# @Contact   :   2597578239@qq.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   Take the test dblatex option
# #############################################

source "common/common.sh"

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    common_config_params
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    common_pre
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    dblatex -h | grep "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    dblatex --help | grep "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    dblatex -v | grep -E "version|[0-9]"
    CHECK_RESULT $? 0 0 "option: -v error"
    dblatex --version | grep -E "version|[0-9]"
    CHECK_RESULT $? 0 0 "option: --version error"
    # -o OUTPUT, --output=OUTPUT
    dblatex -o ${TMP_DIR}/test1.pdf common/test-1/test.xml 2>&1 | grep "successfully built" && \
    test -f ${TMP_DIR}/test1.pdf
    CHECK_RESULT $? 0 0 "option: -o error"
    dblatex --output=${TMP_DIR}/test2.pdf common/test-1/test.xml 2>&1 | grep "successfully built" && \
    test -f ${TMP_DIR}/test2.pdf
    CHECK_RESULT $? 0 0 "option: --output=OUTPUT error"
    # -O OUTPUT_DIR, --output-dir=OUTPUT_DIR
    dblatex -O ${TMP_PATH_O1} -P set.book.num=all -P use.id.as.filename=1 common/test-2/test.xml 
    test -f ${TMP_PATH_O1}/bk101.pdf -a -f ${TMP_PATH_O1}/bk102.pdf
    CHECK_RESULT $? 0 0 "option: -O error"
    dblatex --output-dir=${TMP_PATH_O2} -P set.book.num=all -P use.id.as.filename=1 common/test-2/test.xml 
    test -f ${TMP_PATH_O2}/bk101.pdf -a -f ${TMP_PATH_O2}/bk102.pdf
    CHECK_RESULT $? 0 0 "option: --output-dir error"
    for backend in "pdftex" "dvips" "xetex"
    do
        dblatex -b ${backend} -o ${TMP_DIR}/test3.pdf common/test-1/test.xml 2>&1 | grep "successfully built" 
        CHECK_RESULT $? 0 0 "option: -b ${backend} error"
        dblatex --backend=${backend} -o ${TMP_DIR}/test4.pdf common/test-1/test.xml 2>&1 | grep "successfully built" 
        CHECK_RESULT $? 0 0 "option: --backend=${backend} error"
    done
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"