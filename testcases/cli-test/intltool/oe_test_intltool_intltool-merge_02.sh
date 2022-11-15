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
    cp -rf test_input/intltool_merge/* ./
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    intltool-merge --help | grep -i "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-merge --version | grep -E "intltool-merge.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"
    
    intltool-merge -u -r po test.rfc822deb test_utf8.rfc822deb.out
    test -f test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -u -r generate error"
    grep -i "rfc822deb" test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: -u error"
    rm -rf test_utf8.rfc822deb.out
    intltool-merge --utf8 -r po test.rfc822deb test_utf8.rfc822deb.out
    test -f test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --utf8 -r generate error"
    grep -i "rfc822deb" test_utf8.rfc822deb.out
    CHECK_RESULT $? 0 0 "option: --utf8 error"
    rm -rf test_utf8.rfc822deb.out
    
    intltool-merge -p -x po test.xml test_pass.xml.out 2>&1 | grep "Warning: option --pass-through"
    CHECK_RESULT $? 0 0 "option: -p error"
    rm -rf test_pass.xml.out
    intltool-merge --pass-through -x po test.xml test_pass.xml.out 2>&1 | grep "Warning: option --pass-through"
    CHECK_RESULT $? 0 0 "option: --pass-through error"
    rm -rf test_pass.xml.out
    
    intltool-merge -m --quoted-style po test.quoted test.quoted.out
    test -f merge_test/test.quoted.out
    CHECK_RESULT $? 0 0 "option: -m --quoted-style generate error"
    grep -i "quoted" merge_test/test.quoted.out
    CHECK_RESULT $? 0 0 "option: -m --quoted-style error"
    rm -rf merge_test
    intltool-merge --multiple-output --quotedxml-style po test.quotedxml test.quotedxml.out
    test -f merge_test/test.quotedxml.out
    CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style generate error"
    grep -i "quotedxml" merge_test/test.quotedxml.out
    CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style error"
    rm -rf merge_test

    intltool-merge --no-translations -x test.xml test_no.xml.out
    test -f test_no.xml.out
    CHECK_RESULT $? 0 0 "option: --no-translations generate error"
    grep -i "<welcome>" test_no.xml.out
    CHECK_RESULT $? 0 0 "option: --no-translations error"
    rm -rf test_no.xml.out

    intltool-merge po/ -x -c po/.intltool-merge-cache test.xml test_cache.xml.out
    test -f po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: -c generate error"
    grep -i "xml" po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: -c error"
    rm -rf po/.intltool-merge-cache test_cache.xml.out
    intltool-merge po/ -x --cache=po/.intltool-merge-cache test.xml test_cache.xml.out
    test -f po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: --cache generate error"
    grep -i "xml" po/.intltool-merge-cache
    CHECK_RESULT $? 0 0 "option: --cache=FILE error"
    rm -rf po/.intltool-merge-cache test_cache.xml.out
    intltool-merge -q -k po test.keys test_quiet.keys.out
    CHECK_RESULT $? 0 0 "option: -q error"
    rm -rf test_quiet.keys.out
    intltool-merge --quiet -k po test.keys test_quiet.keys.out
    CHECK_RESULT $? 0 0 "option: --quiet error"
    rm -rf test_quiet.keys.out

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

