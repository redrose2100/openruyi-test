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

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    local_LANG=$LANG
    export LANG=en_US.UTF-8
    test -d tmp || mkdir tmp
    cp -rf common/intltool_extract/* tmp
    tar -xf ./tmp/common.tar -C ./tmp
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    intltool-extract -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    intltool-extract --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    intltool-prepare -v | grep -E "intltool-prepare intltool [0-9].+"
    CHECK_RESULT $? 0 0 "option: -v error"
    intltool-prepare --version | grep -E "intltool-prepare intltool [0-9].+"
    CHECK_RESULT $? 0 0 "option: --version error"

    for type in "glade" "ini" "keys" "rfc822deb"  \
                "schemas" "gsettings" "xml" "tlk" \
                "quoted" "quotedxml" "qtdesigner"
    do
        intltool-extract --type="gettext/${type}" ./tmp/common/test.${type} | grep -i "Wrote" 
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
        test -f ./tmp/common/test.${type}.h
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
        grep -i "char" ./tmp/common/test.${type}.h
        CHECK_RESULT $? 0 0 "option: --type=\"gettext/${type}\" error"
    done

    intltool-extract --type="gettext/xml" ./tmp/test.xml -l | grep -i "Wrote"
    CHECK_RESULT $? 0 0 "option: -l error"
    test -f ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -l error"
    grep -i "char" ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -l error"
    rm -rf ./tmp/test.xml.h
    intltool-extract --type="gettext/xml" ./tmp/test.xml --local | grep -i "Wrote"
    CHECK_RESULT $? 0 0 "option: --local error"
    test -f ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -l error"
    grep -i "char" ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: --local error"

    cp -bf ./tmp/test.new.xml ./tmp/test.xml
    intltool-extract --type="gettext/xml" ./tmp/test.xml --update | grep -i "Wrote"
    CHECK_RESULT $? 0 0 "option: --update error"
    test -f ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: --update error"
    grep -i "new" ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: --update error"
    mv -f ./tmp/test.xml~ ./tmp/test.xml
    
    rm -rf ./tmp/test.xml.h
    intltool-extract --type="gettext/xml" test.xml --srcdir ./tmp | grep -i "Wrote"
    CHECK_RESULT $? 0 0 "option: --srcdir error"
    test -f test.xml.h
    CHECK_RESULT $? 0 0 "option: --srcdir error"
    grep -i "char" test.xml.h
    CHECK_RESULT $? 0 0 "option: --srcdir error"

    rm -rf test.xml.h
    OUTPUT=$(intltool-extract --type="gettext/xml" ./tmp/test.xml -q) 
    grep -i "char" ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: -q error"
    test -z "${OUTPUT}" -a $? -eq 0
    CHECK_RESULT $? 0 0 "option: -q error"
    rm -rf ./tmp/test.xml.h
    OUTPUT=$(intltool-extract --type="gettext/xml" ./tmp/test.xml --quiet)
    grep -i "char" ./tmp/test.xml.h
    CHECK_RESULT $? 0 0 "option: --quiet error"
    test -z "${OUTPUT}" -a $? -eq 0 
    CHECK_RESULT $? 0 0 "option: --quiet error"

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

