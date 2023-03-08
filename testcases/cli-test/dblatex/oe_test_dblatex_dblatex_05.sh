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
    # -r SCRIPT, --texpost=SCRIPT
    dblatex -r plugin:common/test-1/test common/test-1/test.xml 2>&1 | grep "Plugin"
    CHECK_RESULT $? 0 0 "option: -r error"
    dblatex --texpost=plugin:common/test-1/test common/test-1/test.xml 2>&1 | grep "Plugin" 
    CHECK_RESULT $? 0 0 "option: --texpost error"
    # -s STYFILE, --texstyle=STYFILE
    dblatex -o ${TMP_DIR}/test1.pdf -s common/test-1/test.sty common/test-1/test.xml 2>&1 | grep "successfully built" 
    CHECK_RESULT $? 0 0 "option: -s error"
    dblatex -o ${TMP_DIR}/test2.pdf --texstyle=common/test-1/test.sty common/test-1/test.xml 2>&1 | grep "successfully built"
    CHECK_RESULT $? 0 0 "option: --texstyle error"
    # FORMAT: tex, dvi, ps, pdf
    # -t FORMAT, --type=FORMAT (default=pdf) ; --FORMAT (except tex)
    for format in "tex" "dvi" "ps" "pdf"
    do
        dblatex -o ${TMP_DIR}/test3.pdf -t ${format} common/test-1/test.xml 2>&1 | grep "successfully" 
        CHECK_RESULT $? 0 0 "option: -t ${format} error"
        dblatex -o ${TMP_DIR}/test4.pdf --type=${format} common/test-1/test.xml 2>&1 | grep "successfully" 
        CHECK_RESULT $? 0 0 "option: --type=${format} error"
        if [ ${format} != "tex" ]; then
            dblatex -o ${TMP_DIR}/test5.pdf --${format} common/test-1/test.xml 2>&1 | grep "successfully" 
            CHECK_RESULT $? 0 0 "option: --${format} error"
        fi
    done
    # -T STYLE, --style=STYLE
    for style in "db2latex" "native" "simple"
    do
        dblatex -o ${TMP_DIR}/test6.pdf -T ${style} common/test-1/test.xml 2>&1 | grep "successfully built"
        CHECK_RESULT $? 0 0 "option: -T ${style} error"
        dblatex -o ${TMP_DIR}/test7.pdf --style=${style} common/test-1/test.xml 2>&1 | grep "successfully built" 
        CHECK_RESULT $? 0 0 "option: --style=${style} error"
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
