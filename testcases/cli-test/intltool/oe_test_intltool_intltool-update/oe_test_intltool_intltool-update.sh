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
    test -d tmp || mkdir tmp
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    local_LANG=$LANG
    export LANG=en_US.UTF-8
    cp -rf test_input/* tmp
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    intltool-update --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-update --version | grep -E "intltool-update.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    cd tmp/po
    intltool-update -p 
    grep -i "hello, i am xml." untitled.pot
    CHECK_RESULT $? 0 0 "option: -p error"
    rm -rf untitled.pot
    intltool-update --pot
    grep -i "hello, i am xml." untitled.pot
    CHECK_RESULT $? 0 0 "option: --pot error"
    rm -rf untitled.pot

    intltool-update -p -g "test_output"
    grep -i "hello, i am xml.*" test_output.pot
    CHECK_RESULT $? 0 0 "option: -g error"
    rm -rf test_output.pot
    intltool-update -p --gettext-package="test_output"
    grep -i "hello, i am xml.*" test_output.pot
    CHECK_RESULT $? 0 0 "option: --gettext-package=NAME error"
    rm -rf test_output.pot

    intltool-update -s
    grep -i "char.*hello, i am xml.*" ../extract.xml.h
    CHECK_RESULT $? 0 0 "option: -s error"
    rm -rf ../extract.xml.h
    intltool-update --headers
    grep -i "char.*hello, i am xml.*" ../extract.xml.h
    CHECK_RESULT $? 0 0 "option: --headers error"
    rm -rf ../extract.xml.h

    intltool-update -x -s | grep -i "Wrote ../extract.xml.h"
    CHECK_RESULT $? 0 0 "option: -x error"
    rm -rf ../extract.xml.h
    intltool-update --verbose -s | grep -i "Wrote ../extract.xml.h"
    CHECK_RESULT $? 0 0 "option: --verbose error"
    rm -rf ../extract.xml.h

    intltool-update -x -m | grep -i "Searching for missing"
    CHECK_RESULT $? 0 0 "option: -m error"
    rm -rf missing
    intltool-update -x --maintain | grep -i "Searching for missing"
    CHECK_RESULT $? 0 0 "option: --maintain error"
    rm -rf missing

    intltool-update -r 2>&1 | grep -i "2 translated messages, 1 fuzzy translation, 2 untranslated messages."
    CHECK_RESULT $? 0 0 "option: -r error"
    grep -i "hello, i am xml.*" untitled.pot | grep 5
    CHECK_RESULT $? 0 0 "option: -r error"
    rm -rf untitled.pot
    intltool-update --report 2>&1 | grep -i "2 translated messages, 1 fuzzy translation, 2 untranslated messages."
    CHECK_RESULT $? 0 0 "option: --report error"
    grep -i "hello, i am xml.*" untitled.pot | grep 5
    CHECK_RESULT $? 0 0 "option: --report error"
    rm -rf untitled.pot

    intltool-update -g test_input -d test_input -o test.out 2>&1 | grep -i "2 translated messages, 1 fuzzy translation, 2 untranslated messages." 
    CHECK_RESULT $? 0 0 "option: -d -o error"
    grep -i "hello, i am xml" test.out
    CHECK_RESULT $? 0 0 "option: -d -o error"
    rm -rf test.out
    intltool-update -g test_input --dist test_input --output-file=test.out 2>&1 | grep -q "2 translated messages, 1 fuzzy translation, 2 untranslated messages."
    CHECK_RESULT $? 0 0 "option: --dist test_input --output-file error"
    grep -i "hello, i am xml" test.out
    CHECK_RESULT $? 0 0 "option: --dist --output-file=FILE error"
    rm -rf test.out

    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ../../tmp
    DNF_REMOVE
    export LANG=${local_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"

