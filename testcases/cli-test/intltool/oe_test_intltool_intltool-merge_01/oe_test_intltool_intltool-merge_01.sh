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

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
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
    intltool-merge --help | grep "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-merge --version | grep -E "intltool-merge.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    cd tmp
    
    intltool-merge -d po test.desktop test.desktop.out
    test -f test.desktop.out
    CHECK_RESULT $? 0 0 "option: -d generate error"
    grep "你好，我是desktop文件" test.desktop.out
    CHECK_RESULT $? 0 0 "option: -d error"
    rm -rf test.desktop.out
    intltool-merge --desktop-style po test.desktop test.desktop.out
    test -f test.desktop.out
    CHECK_RESULT $? 0 0 "option: --desktop-style generate error"
    grep "你好，我是desktop文件" test.desktop.out
    CHECK_RESULT $? 0 0 "option: --desktop-style error"
    
    intltool-merge -k po test.keys test.keys.out
    test -f test.keys.out
    CHECK_RESULT $? 0 0 "option: -k generate error"
    grep "你好，我是keys文件" test.keys.out
    CHECK_RESULT $? 0 0 "option: -k error"
    rm -rf test.keys.out
    intltool-merge --keys-style po test.keys test.keys.out
    test -f test.keys.out
    CHECK_RESULT $? 0 0 "option: --keys-style generate error"
    grep "你好，我是keys文件" test.keys.out
    CHECK_RESULT $? 0 0 "option: --keys-style error"

    intltool-merge -s po test.schemas test.schemas.out
    test -f test.schemas.out
    CHECK_RESULT $? 0 0 "option: -s generate error"
    grep "你好，我是schemas文件" test.schemas.out
    CHECK_RESULT $? 0 0 "option: -s error"
    rm -rf test.schemas.out
    intltool-merge --schemas-style po test.schemas test.schemas.out
    test -f test.schemas.out
    CHECK_RESULT $? 0 0 "option: --schemas-style generate error"
    grep "你好，我是schemas文件" test.schemas.out
    CHECK_RESULT $? 0 0 "option: --schemas-style error"

    intltool-merge -r po test.rfc822deb test.rfc822deb.out
    test -f test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -r generate error"
    grep "你好，我是rfc822deb文件" test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -r error"
    rm -rf test.rfc822deb.out
    intltool-merge --rfc822deb-style po test.rfc822deb test.rfc822deb.out
    test -f test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --rfc822deb-style generate error"
    grep "你好，我是rfc822deb文件" test.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --rfc822deb-style error"
    
    intltool-merge -x po test.xml test.xml.out
    test -f test.xml.out
    CHECK_RESULT $? 0 0 "option: -x error"
    grep "你好，我是xml文件" test.xml.out
    CHECK_RESULT $? 0 0 "option: -x error"
    rm -rf test.xml.out
    intltool-merge --xml-style po test.xml test.xml.out
    test -f test.xml.out
    CHECK_RESULT $? 0 0 "option: --xml-style error"
    grep "你好，我是xml文件" test.xml.out
    CHECK_RESULT $? 0 0 "option: --xml-style error"
    cd ../../
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf oe_test_intltool_intltool-merge_01/tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

