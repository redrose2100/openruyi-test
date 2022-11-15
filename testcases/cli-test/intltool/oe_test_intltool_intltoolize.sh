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

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    local_LANG=$LANG
    export LANG=en_US.UTF-8
    cp -rf test_input/intltoolize/* ./
    mkdir -p ./po
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    intltoolize --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltoolize --version | grep -E "intltoolize.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"

    intltoolize --automake  
    grep -c "Makefile" po/Makefile.in.in | grep 9
    CHECK_RESULT $? 0 0 "option: --automake error"
    ls -Al po/Makefile.in.in | grep "\->" 
    CHECK_RESULT $? 0 0 "option: --automake error"

    rm -rf po/*
    intltoolize -c
    grep -c "Makefile" po/Makefile.in.in | grep 9
    CHECK_RESULT $? 0 0 "option: -c error"
    rm -rf po/*
    intltoolize --copy
    grep -c "Makefile" po/Makefile.in.in | grep 9
    CHECK_RESULT $? 0 0 "option: --copy error"

    rm -rf po/*
    intltoolize --debug 2>&1 | grep "exit 0"
    CHECK_RESULT $? 0 0 "option: --debug error" 
    grep -c "Makefile" po/Makefile.in.in | grep 9
    CHECK_RESULT $? 0 0 "option: --debug error" 

    intltoolize --debug -n 2>&1 | grep "dry_run=yes"
    CHECK_RESULT $? 0 0 "option: -n error"
    intltoolize --debug -f 2>&1 | grep "force=yes"
    CHECK_RESULT $? 0 0 "option: -f error" 
    intltoolize --debug --force 2>&1 | grep "force=yes"
    CHECK_RESULT $? 0 0 "option: --force error" 
    
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf po aclocal.m4 configure.in
    DNF_REMOVE
    export LANG=${local_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
