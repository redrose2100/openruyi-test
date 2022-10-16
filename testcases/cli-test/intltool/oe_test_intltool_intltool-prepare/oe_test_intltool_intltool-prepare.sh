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

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."

    TMP_DIR="$(mktemp -d -t intltool.XXXXXXXXXXXX)"

    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etcd
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "intltool"
    cp -rf test_input/* ${TMP_DIR}
    mkdir -p ${TMP_DIR}/po

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    intltool-prepare -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    intltool-prepare --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    intltool-prepare -v | grep -qE "intltool-prepare.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: -v error"
    intltool-prepare --version | grep -qE "intltool-prepare.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"

    cd ${TMP_DIR}

    intltool-prepare 2>&1 | grep "Working" > /dev/null && \
        cat po/POTFILES.in | grep -q $'extract1.desktop.in\nmerge8.keys.in' && \
        cat po/test.po | grep -q "msgstr" && \
        cat .cvsignore | grep -q $'extract1.desktop\nmerge8.keys' && \
        cat extract1.desktop.in | grep -q "Desktop Entry" && \
        cat merge8.keys.in | grep -q "_description" && \
        test -f Makefile.am
    CHECK_RESULT $? 0 0 "intltool-prepare output error"
    rm -rf po/* *.in .cvsignore Makefile.am*

    intltool-prepare -x 2>&1 | grep -E "Appending|Generating" > /dev/null && \
        cat po/POTFILES.in | grep -q $'extract1.desktop.in\nmerge8.keys.in' && \
        cat po/test.po | grep -q "msgstr" && \
        cat .cvsignore | grep -q $'extract1.desktop\nmerge8.keys' && \
        cat extract1.desktop.in | grep -q "Desktop Entry" && \
        cat merge8.keys.in | grep -q "_description" && \
        test -f Makefile.am
    CHECK_RESULT $? 0 0 "option: -x error"
    rm -rf po/* *.in .cvsignore Makefile.am*

    intltool-prepare --verbose 2>&1 | grep -E "Appending|Generating" > /dev/null && \
        cat po/POTFILES.in | grep -q $'extract1.desktop.in\nmerge8.keys.in' && \
        cat po/test.po | grep -q "msgstr" && \
        cat .cvsignore | grep -q $'extract1.desktop\nmerge8.keys' && \
        cat extract1.desktop.in | grep -q "Desktop Entry" && \
        cat merge8.keys.in | grep -q "_description" && \
        test -f Makefile.am
    CHECK_RESULT $? 0 0 "option: --verbose error"
    rm -rf po/* *.in .cvsignore Makefile.am*

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
