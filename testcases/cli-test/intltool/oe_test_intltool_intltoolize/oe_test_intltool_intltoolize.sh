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
# @Author    :   zhaxicao
# @Contact   :   3245853698@qq.com
# @Date      :   2022/10/02
# @License   :   Mulan PSL v2
# @Desc      :   TEST intltoolize options
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
    cp -rf test_input/* ${TMP_DIR}
    mkdir -p ${TMP_DIR}/po
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    intltoolize --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltoolize --version | grep -qE "intltoolize.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    cd ${TMP_DIR}
    rm -rf po/*
    intltoolize --automake && \
        cat po/Makefile.in.in | grep -q "Makefile" && 
        ls -Al po/Makefile.in.in | grep -q "\->"
    CHECK_RESULT $? 0 0 "option: --automake error"
    rm -rf po/*
    intltoolize -c && \
        cat po/Makefile.in.in | grep -q "Makefile"
    CHECK_RESULT $? 0 0 "option: -c error"
    rm -rf po/*
    intltoolize --copy && \
        cat po/Makefile.in.in | grep -q "Makefile"
    CHECK_RESULT $? 0 0 "option: --copy error"
    rm -rf po/*
    intltoolize --debug 2>&1 | grep -q "exit 0" && \
        cat po/Makefile.in.in | grep -q "Makefile" 
    CHECK_RESULT $? 0 0 "option: --debug error" 
    intltoolize --debug -n 2>&1 | grep -q "dry_run=yes"
    CHECK_RESULT $? 0 0 "option: -n error"
    intltoolize --debug -f 2>&1 | grep -q "force=yes"
    CHECK_RESULT $? 0 0 "option: -f error" 
    intltoolize --debug --force 2>&1 | grep -q "force=yes"
    CHECK_RESULT $? 0 0 "option: --force error" 
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
