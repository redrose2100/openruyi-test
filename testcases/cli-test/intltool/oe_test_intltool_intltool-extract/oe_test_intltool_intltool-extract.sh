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
    local_LANG=$LANG
    export LANG=en_US
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    test -d tmp || mkdir tmp
    cp -rf test_input/* tmp
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    intltool-extract -h | grep "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    intltool-extract --help | grep "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    intltool-prepare -v | grep -E "intltool-prepare intltool [0-9].+"
    CHECK_RESULT $? 0 0 "option: -v error"
    intltool-prepare -v | grep -E "intltool-prepare intltool [0-9].+"
    CHECK_RESULT $? 0 0 "option: --version error"


    cd tmp
    tar -xvf common.tar 
    for type in "glade" "ini" "keys" "rfc822deb"  \
                "schemas" "gsettings" "xml" "tlk" \
                "quoted" "quotedxml" "qtdesigner"
    do
        intltool-extract --type="gettext/${type}" common/test.${type} | grep "Wrote" 
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
        test -f common/test.${type}.h
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
        grep "char" common/test.${type}.h
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
    done

    intltool-extract --type="gettext/xml" test.xml -l | grep "Wrote"
    CHECK_RESULT $? 0 0 "option: -l error"
    test -f tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -l error"
    grep "char" tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -l error"
    rm -rf tmp/test.xml.h
    intltool-extract --type="gettext/xml" test.xml --local | grep "Wrote"
    CHECK_RESULT $? 0 0 "option: --local error"
    test -f tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -l error"
    grep "char" tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: --local error"

    cp -bf test.new.xml test.xml
    intltool-extract --type="gettext/xml" test.xml --update | grep "Wrote"
    CHECK_RESULT $? 0 0 "option: --update error"
    test -f test.xml.h
    CHECK_RESULT $? 0 0 "option: --update error"
    grep "new" test.xml.h
    CHECK_RESULT $? 0 0 "option: --update error"
    mv -f test.xml~ test.xml
    
    rm -rf test.xml.h
    cp test.xml ./tmp
    intltool-extract --type="gettext/xml" test.xml --srcdir ./tmp | grep "Wrote"
    CHECK_RESULT $? 0 0 "option: --srcdir error"
    test -f test.xml.h
    CHECK_RESULT $? 0 0 "option: --srcdir error"
    grep "char" test.xml.h
    CHECK_RESULT $? 0 0 "option: --srcdir error"

    rm -rf test.xml.h
    OUTPUT=$(intltool-extract --type="gettext/xml" test.xml -q) 
    grep "char" test.xml.h
    CHECK_RESULT $? 0 0 "option: -q error"
    test -z "${OUTPUT}" -a $? -eq 0
    CHECK_RESULT $? 0 0 "option: -q error"
    rm -rf test.xml.h
    OUTPUT=$(intltool-extract --type="gettext/xml" test.xml --quiet)
    grep "char" test.xml.h
    CHECK_RESULT $? 0 0 "option: --quiet error"
    test -z "${OUTPUT}" -a $? -eq 0 
    CHECK_RESULT $? 0 0 "option: --quiet error"

    cd ../

    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp
    DNF_REMOVE
    export LANG=${local_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"

