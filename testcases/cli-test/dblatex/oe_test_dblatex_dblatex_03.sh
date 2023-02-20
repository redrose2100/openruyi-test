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
    # -f FIG_FORMAT, --fig-format=FIG_FORMAT
    for fit_format in "eps" "fig" "pdf"
    do
        dblatex -o ${TMP_DIR}/test1.pdf -f ${fit_format} common/test-1/test.xml 2>&1 | grep "successfully built"
        CHECK_RESULT $? 0 0 "option: -f ${fit_format} error"
        dblatex -o ${TMP_DIR}/test2.pdf--fig-format=${fit_format} common/test-1/test.xml 2>&1 | grep "successfully built" 
        CHECK_RESULT $? 0 0 "option: --fig-format=${fit_format} error"
    done
    # -F INPUT_FORMAT, --input-format=INPUT_FORMAT
    dblatex -o ${TMP_DIR}/test3.pdf -F xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -F xml error"
    dblatex -o ${TMP_DIR}/test4.pdf --input-format=xml common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --input-format=${input_format} error"
    # -i TEXINPUTS, --texinputs=TEXINPUTS
    dblatex -o ${TMP_DIR}/test5.pdf -i "export" common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -i error"
    dblatex -o ${TMP_DIR}/test6.pdf --texinputs="export"  common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --texinputs error"  
    # -I FIG_PATH, --fig-path=FIG_PATH
    dblatex -o ${TMP_DIR}/test7.pdf -I common/test-3/ -I /project/mugen/testcases/ -I /srv common/test-1/test.sgml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: -I error"
    dblatex -o ${TMP_DIR}/test8.pdf --fig-path=common/test-3/ --fig-path=/project/mugen/testcases/ --fig-path=/srv common/test-1/test.sgml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: --fig-path error"
    # -l BST_PATH, --bst-path=BST_PATH
    dblatex -o ${TMP_DIR}/test9.pdf -l common/test-1/ -L common/test-1/   common/test-4/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -l error"
    dblatex -o ${TMP_DIR}/test10.pdf --bst-path=common/test-1/ -L common/test-1/   common/test-4/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --bst-path error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
