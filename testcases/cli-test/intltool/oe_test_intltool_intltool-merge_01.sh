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
# @Date      :   2022/10/05
# @License   :   Mulan PSL v2
# @Desc      :   Test intltool-merge
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
    local_LANG=$LANG
    export LANG=en_US.UTF-8
    cp -rf common/intltool_merge/* ./
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    intltool-merge --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-merge --version | grep -E "intltool-merge.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    
    intltool-merge -d po test.desktop test.desktop.out
    test -f test.desktop.out
    CHECK_RESULT $? 0 0 "option: -d generate error"
    grep -i "desktop" test.desktop.out
    CHECK_RESULT $? 0 0 "option: -d error"
    rm -rf test.desktop.out
    intltool-merge --desktop-style po test.desktop test.desktop.out
    test -f test.desktop.out
    CHECK_RESULT $? 0 0 "option: --desktop-style generate error"
    grep -i "desktop" test.desktop.out
    CHECK_RESULT $? 0 0 "option: --desktop-style error"
    rm -rf test.desktop.out
    
    intltool-merge -k po test.keys test.keys.out
    test -f test.keys.out
    CHECK_RESULT $? 0 0 "option: -k generate error"
    grep -i "keys" test.keys.out
    CHECK_RESULT $? 0 0 "option: -k error"
    rm -rf test.keys.out
    intltool-merge --keys-style po test.keys test.keys.out
    test -f test.keys.out
    CHECK_RESULT $? 0 0 "option: --keys-style generate error"
    grep -i "keys" test.keys.out
    CHECK_RESULT $? 0 0 "option: --keys-style error"
    rm -rf test.keys.out

    intltool-merge -s po test.schemas test.schemas.out
    test -f test.schemas.out
    CHECK_RESULT $? 0 0 "option: -s generate error"
    grep -i "schemas" test.schemas.out
    CHECK_RESULT $? 0 0 "option: -s error"
    rm -rf test.schemas.out
    intltool-merge --schemas-style po test.schemas test.schemas.out
    test -f test.schemas.out
    CHECK_RESULT $? 0 0 "option: --schemas-style generate error"
    grep -i "schemas" test.schemas.out
    CHECK_RESULT $? 0 0 "option: --schemas-style error"
    rm -rf test.schemas.out

    intltool-merge -r po test.rfc822deb test.rfc822deb.out
    test -f test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -r generate error"
    grep -i "rfc822deb" test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -r error"
    rm -rf test.rfc822deb.out
    intltool-merge --rfc822deb-style po test.rfc822deb test.rfc822deb.out
    test -f test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --rfc822deb-style generate error"
    grep -i "rfc822deb" test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --rfc822deb-style error"
    rm -rf test.rfc822deb.out
    
    intltool-merge -x po test.xml test.xml.out
    test -f test.xml.out
    CHECK_RESULT $? 0 0 "option: -x error"
    grep -i "xml" test.xml.out
    CHECK_RESULT $? 0 0 "option: -x error"
    rm -rf test.xml.out
    intltool-merge --xml-style po test.xml test.xml.out
    test -f test.xml.out
    CHECK_RESULT $? 0 0 "option: --xml-style error"
    grep -i "xml" test.xml.out
    CHECK_RESULT $? 0 0 "option: --xml-style error"
    rm -rf test.xml.out

    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf po test.* .cvsignore Makefile.am
    export LANG=${local_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"

