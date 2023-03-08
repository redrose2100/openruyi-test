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
    # --tmpdir
    mkdir -p ${TMP_PATH}/tmpdir
    dblatex -o ${TMP_DIR}/test1.pdf -d --tmpdir ${TMP_DIR}/tmpdir common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --tmpdir error"
    # -V, --verbose
    dblatex -o ${TMP_DIR}/test2.pdf -V common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -V error"
    dblatex -o ${TMP_DIR}/test3.pdf --verbose common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --verbose error"
    # -x XSLT_OPTIONS, --xslt-opts=XSLT_OPTIONS
    dblatex -o ${TMP_DIR}/test4.pdf -x "--timing" common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -x error"
    dblatex -o ${TMP_DIR}/test5.pdf --xslt-opts="--timing" common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --xslt-opts error"
    # -X, --no-external
    dblatex -o ${TMP_DIR}/test6.pdf -X common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: -X error"
    dblatex -o ${TMP_DIR}/test7.pdf --no-external common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --no-external error"
     # -B, --no-batch
    dblatex -o ${TMP_DIR}/test8.pdf -B common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: -B error"
    dblatex -o ${TMP_DIR}/test9.pdf --no-batch common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --no-batch error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
