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
    test -d tmp || mkdir tmp
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "intltool"
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
    
    intltool-merge -u -r po test.rfc822deb test_utf8.rfc822deb.out
    test -f test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -u -r generate error"
    grep "你好，我是rfc822deb文件" test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -u error"
    rm -rf test_utf8.rfc822deb.out
    intltool-merge --utf8 -r po test.rfc822deb test_utf8.rfc822deb.out
    test -f test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --utf8 -r generate error"
    grep "你好，我是rfc822deb文件" test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --utf8 error"
    
    intltool-merge -p -x po test.xml test_pass.xml.out 2>&1 | grep "Warning: option --pass-through"
    CHECK_RESULT $? 0 0 "option: -p error"
    intltool-merge --pass-through -x po test.xml test_pass.xml.out 2>&1 | grep "Warning: option --pass-through"
    CHECK_RESULT $? 0 0 "option: --pass-through error"
    
    intltool-merge -m --quoted-style po test.quoted test.quoted.out
    test -f merge_test/test.quoted.out
    CHECK_RESULT $? 0 0 "option: -m --quoted-style generate error"
    grep "你好，我是quoted文件" merge_test/test.quoted.out
    CHECK_RESULT $? 0 0 "option: -m --quoted-style error"
    rm -rf merge_test/test.quoted.out
    intltool-merge --multiple-output --quotedxml-style po test.quotedxml test.quotedxml.out
    test -f merge_test/test.quotedxml.out
    CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style generate error"
    grep "你好，我是quotedxml文件" merge_test/test.quotedxml.out
    CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style error"

    intltool-merge --no-translations -x test.xml test_no.xml.out
    test -f test_no.xml.out
    CHECK_RESULT $? 0 0 "option: --no-translations generate error"
    grep -c "<welcome>" test_no.xml.out | grep 1
    CHECK_RESULT $? 0 0 "option: --no-translations error"
    intltool-merge po/ -x -c po/.intltool-merge-cache test.xml test_cache.xml.out
    test -f po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: -c generate error"
    grep "你好，我是.*文件" po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: -c error"
    rm -rf po/.intltool-merge-cache test_cache.xml.out
    intltool-merge po/ -x --cache=po/.intltool-merge-cache test.xml test_cache.xml.out
    test -f po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: --cache generate error"
    grep "你好，我是.*文件" po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: --cache=FILE error"
    intltool-merge -q -k po test.keys test_quiet.keys.out
    CHECK_RESULT $? 0 0 "option: -q error"
    rm -rf test_quiet.keys.out
    intltool-merge --quiet -k po test.keys test_quiet.keys.out
    CHECK_RESULT $? 0 0 "option: --quiet error"
    cd ../../
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf oe_test_intltool_intltool-merge_02/tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

