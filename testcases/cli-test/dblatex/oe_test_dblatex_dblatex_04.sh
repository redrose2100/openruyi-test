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
    # -L BIB_PATH, --bib-path=BIB_PATH
    dblatex -o ${TMP_DIR}/test1.pdf -L common/test-1/  common/test-3/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -L error"
    dblatex -o ${TMP_DIR}/test2.pdf --bib-path=common/test-1/  common/test-3/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --bib-path error"
    # -m XSLT, --xslt=XSLT  XSLT engine to use. (default=xsltproc)
    dblatex -o ${TMP_DIR}/test3.pdf -m xsltproc common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -m xsltproc error"
    dblatex -o ${TMP_DIR}/test4.pdf --xslt=xsltproc common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --xslt=xsltproc error"
    # -p XSL_USER, --xsl-user=XSL_USER
    dblatex -o ${TMP_DIR}/test5.pdf -p common/test-1/test.xsl common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -p error"
    dblatex -o ${TMP_DIR}/test6.pdf --xsl-user=common/test-1/test.xsl common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --xsl-user error"
    # -P PARAM=VALUE, --param=PARAM=VALUE
    dblatex -o ${TMP_DIR}/test7.pdf -P latex.hyperparam=colorlinks,linkcolor=blue common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -P error"
    dblatex -o ${TMP_DIR}/test8.pdf --param=latex.hyperparam=colorlinks,linkcolor=blue common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --param error"
    # -q, --quiet
    dblatex -o ${TMP_DIR}/test9.pdf -q common/test-1/test.xml 2>&1 | grep "section" 
    CHECK_RESULT $? 0 0 "option: -q error"
    dblatex -o ${TMP_DIR}/test10.pdf --quiet common/test-1/test.xml 2>&1 | grep "section"
    CHECK_RESULT $? 0 0 "option: --quiet error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
