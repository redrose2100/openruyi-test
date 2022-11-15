#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details

# #############################################
# @Author    :   zhanglijun
# @Contact   :   2637863032@qq.com
# @Date      :   2022/10/05
# @License   :   Mulan PSL v2
# @Desc      :   Test intltool-prepare options
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
   LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    local_LANG=$LANG
    test -d tmp || mkdir tmp 
    mkdir -p po
    export LANG=en_US.UTF-8
    cp -rf test_input/intltool_prepare/* tmp
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    intltool-prepare -h | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    intltool-prepare --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    intltool-prepare -v | grep -E "intltool-prepare intltool [0-9].+"
    CHECK_RESULT $? 0 0 "option: -v error"
    intltool-prepare -v | grep -E "intltool-prepare intltool [0-9].+"
    CHECK_RESULT $? 0 0 "option: --version error"

    tar -xvf ./tmp/common.tar -C ./tmp
    intltool-prepare 2>&1 | grep -i "Working"
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    grep -i $'extract1.desktop.in\nmerge8.keys.in' po/POTFILES.in
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    grep -i "msgstr" po/test.po
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    grep -i $'extract1.desktop\nmerge8.keys' ./tmp/common/.cvsignore
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    grep -i "Desktop Entry" ./tmp/common/extract1.desktop.in
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    grep -i "_description" ./tmp/common/merge8.keys.in
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    test -f ./tmp/common/Makefile.am
    CHECK_RESULT $? 0 0 "intltool-prepare output error"

    intltool-prepare -x 2>&1 | grep -E "Appending|Generating"
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
    grep -i $'extract1.desktop.in\nmerge8.keys.in' po/POTFILES.in
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
    grep -i "msgstr" po/test.po
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
    grep -i $'extract1.desktop\nmerge8.keys' ./tmp/common/.cvsignore
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
    grep -i "Desktop Entry" ./tmp/common/extract1.desktop.in
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
    grep -i "_description" ./tmp/common/merge8.keys.in
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"
    test -f ./tmp/common/Makefile.am
    CHECK_RESULT $? 0 0 "intltool-prepare -x output error"

    intltool-prepare --verbose 2>&1 | grep -E "Appending|Generating"
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"
    grep -i $'extract1.desktop.in\nmerge8.keys.in' po/POTFILES.in
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"
    grep -i "msgstr" po/test.po
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"
    grep -i $'extract1.desktop\nmerge8.keys' ./tmp/common/.cvsignore
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"
    grep -i "Desktop Entry" ./tmp/common/extract1.desktop.in
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"
    grep -i "_description" ./tmp/common/merge8.keys.in
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"
    test -f ./tmp/common/Makefile.am
    CHECK_RESULT $? 0 0 "intltool-prepare --verbose output error"

    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp po
    DNF_REMOVE
    export LANG=${local_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
