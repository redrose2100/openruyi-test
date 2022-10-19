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
# @Author    :   wangxiao
# @Contact   :   1814039487@qq.com
# @Date      :   2022/10/06
# @License   :   Mulan PSL v2
# @Desc      :   Test intltool-update options
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    TMP_DIR="./tmp"
    export LANG=en_US
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
   LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    cp -rf test_input/* ${TMP_DIR}
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    intltool-update --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-update --version | grep -qE "intltool-update.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    cd ${TMP_DIR}/po
    intltool-update -p && cat untitled.pot | grep -c "hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: -p error"
    rm -rf untitled.pot
    intltool-update --pot && cat untitled.pot | grep -c "hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: --pot error"
    rm -rf untitled.pot
    intltool-update -p -g "test_output" && cat test_output.pot | grep -c "hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: -g error"
    rm -rf test_output.pot
    intltool-update -p --gettext-package="test_output" && cat test_output.pot | grep -c "hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: --gettext-package=NAME error"
    rm -rf test_output.pot
    intltool-update -s && cat ../extract.xml.h | grep -c "char.*hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: -s error"
    rm -rf ../extract.xml.h
    intltool-update --headers && cat ../extract.xml.h | grep -c "char.*hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: --headers error"
    rm -rf ../extract.xml.h
    intltool-update -x -s | grep -q "Wrote ../extract.xml.h"
    CHECK_RESULT $? 0 0 "option: -x error"
    rm -rf ../extract.xml.h
    intltool-update --verbose -s | grep -q "Wrote ../extract.xml.h"
    CHECK_RESULT $? 0 0 "option: --verbose error"
    rm -rf ../extract.xml.h
    intltool-update -x -m | grep -q "Searching for missing"
    CHECK_RESULT $? 0 0 "option: -m error"
    intltool-update -x --maintain | grep -q "Searching for missing"
    CHECK_RESULT $? 0 0 "option: --maintain error"
    intltool-update -r 2>&1 | grep "2 translated messages, 1 fuzzy translation, untranslated messages." && \
        cat untitled.pot | grep -c "hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: -r error"
    rm -rf untitled.pot
    intltool-update --report 2>&1 | grep "2 translated messages, 1 fuzzy translation, untranslated messages." && \
        cat untitled.pot | grep -c "hello, i am xml.*" | grep -q "5"
    CHECK_RESULT $? 0 0 "option: --report error"
    rm -rf untitled.pot
    intltool-update -g test_input -d test_input -o test.out 2>&1 | grep -q "2 translated messages, 1 fuzzy translation, untranslated messages." && \
        cat test.out | grep -cE "msgstr ""|xml__2|xml__3|#~ msgstr.*xml__7" | grep -q "6"
    CHECK_RESULT $? 0 0 "option: -d -o error"
    rm -rf test.out
    intltool-update -g test_input --dist test_input --output-file=test.out 2>&1 | grep -q "2 translated messages, 1 fuzzy translation, untranslated messages." && \
        cat test.out | grep -cE "msgstr ""|xml__2|xml__3|#~ msgstr.*xml__7" | grep -q "6"
    CHECK_RESULT $? 0 0 "option: --dist --output-file=FILE error"
    rm -rf test.out
    cd - > /dev/null
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

