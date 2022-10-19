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
# @Author    :   zhanglijun wangxiao zhaxicao
# @Contact   :   2637863032@qq.com
# @Date      :   2022/10/02
# @License   :   Mulan PSL v2
# @Desc      :   Test intltool-extract
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    TMP_DIR="./tmp"
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    cp -rf test_input ${TMP_DIR}
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    intltool-extract -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    intltool-extract --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-extract -v | grep -qE "intltool-extract.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: -v error"
    intltool-extract --version | grep -qE "intltool-extract.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    cd ${TMP_DIR}
    for type in "glade" "ini" "keys" "rfc822deb"  \
                "schemas" "gsettings" "xml" "tlk" \
                "quoted" "quotedxml" "qtdesigner"
    do
        intltool-extract --type="gettext/${type}" test_input/test.${type} | grep -q "Wrote" && \
            cat test_input/test.${type}.h | grep -q "char"
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
    done
    intltool-extract --type="gettext/xml" test_input/test.xml -l | grep -q "Wrote" && \
        cat tmp/test.xml.h | grep -q "char"
    CHECK_RESULT $? 0 0 "option: -l error"
    rm -rf tmp/test.xml.h
    intltool-extract --type="gettext/xml" test_input/test.xml --local | grep -q "Wrote" && \
        cat tmp/test.xml.h | grep -q "char"
    CHECK_RESULT $? 0 0 "option: --local error"
    cp -bf test_input/test.new.xml test_input/test.xml
    intltool-extract --type="gettext/xml" test_input/test.xml --update | grep -q "Wrote" && \
        cat test_input/test.xml.h | grep -q "new"
    CHECK_RESULT $? 0 0 "option: --update error"
    mv -f test_input/test.xml~ test_input/test.xml
    intltool-extract --type="gettext/xml" test.xml --srcdir ./test_input | grep -q "Wrote" && \
        cat test.xml.h | grep -q "char"
    CHECK_RESULT $? 0 0 "option: --srcdir error"
    rm -rf test_input/test.xml.h
    OUTPUT=$(intltool-extract --type="gettext/xml" test_input/test.xml -q) && \
        cat test_input/test.xml.h | grep -q "char"
    test -z "${OUTPUT}" -a $? -eq 0
    CHECK_RESULT $? 0 0 "option: -q error"
    rm -rf test_input/test.xml.h
    OUTPUT=$(intltool-extract --type="gettext/xml" test_input/test.xml --quiet) && \
        cat test_input/test.xml.h | grep -q "char"
    test -z "${OUTPUT}" -a $? -eq 0 
    CHECK_RESULT $? 0 0 "option: --quiet error"
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

