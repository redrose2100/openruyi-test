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
    # -c CONFIG, -S CONFIG, --config=CONFIG
    dblatex -o ${TMP_DIR}/test1.pdf -c common/test-1/test.config.xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -c error"
    dblatex -o ${TMP_DIR}/test2.pdf -S common/test-1/test.config.xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -S error"
    dblatex -o ${TMP_DIR}/test3.pdf --config=common/test-1/test.config.xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --config error"
    # -C CHANGEDIR, --changedir=CHANGEDIR
    dblatex -o ${TMP_DIR}/test4.pdf -C common/test-1/test.config.xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -C error"
    dblatex -o ${TMP_DIR}/test5.pdf --changedir=common/test-1/test.config.xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --changedir error"
    # -d, --debug
    dblatex -o ${TMP_DIR}/test6.pdf -d common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -d error"
    dblatex -o ${TMP_DIR}/test7.pdf --debug common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --debug error"
    # -D, --dump 
    dblatex -o ${TMP_DIR}/test8.pdf -D ${TEST_CASE}/test-1/test2.xml 2>&1 | grep "most recent call last"
    CHECK_RESULT $? 0 0 "option: -D error"
    dblatex -o ${TMP_DIR}/test9.pdf --dump ${TEST_CASE}/test-1/test2.xml 2>&1 | grep "most recent call last"
    CHECK_RESULT $? 0 0 "option: --dump error"
    # -e INDEXSTYLE, --indexstyle=INDEXSTYLE
    dblatex -o ${TMP_DIR}/test10.pdf -e common/test-1/doc.ist common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: -e error"
    dblatex -o ${TMP_DIR}/test11.pdf --indexstyle=common/test-1/doc.ist common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --indexstyle error" 
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
