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

    TMP_DIR="$(mktemp -d -t intltool.XXXXXXXXXXXX)"

    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "intltool"
    cp -rf test_input/* ${TMP_DIR}

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    intltool-merge --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    intltool-merge --version | grep -qE "intltool-merge.*[0-9.]+"
    CHECK_RESULT $? 0 0 "option: --version error"

    cd ${TMP_DIR}
    
    intltool-merge -d po test.desktop test.desktop.out | grep -q "Merging" && \
        cat test.desktop.out | grep -q "你好，我是desktop文件"
    CHECK_RESULT $? 0 0 "option: -d error"
    rm -rf test.desktop.out
    intltool-merge --desktop-style po test.desktop test.desktop.out | grep -q "Merging" && \
        cat test.desktop.out | grep -q "你好，我是desktop文件"
    CHECK_RESULT $? 0 0 "option: --desktop-style error"
    intltool-merge -k po test.keys test.keys.out | grep -q "Merging" && \
        cat test.keys.out | grep -q "你好，我是keys文件"
    CHECK_RESULT $? 0 0 "option: -k error"
    rm -rf test.keys.out
    intltool-merge --keys-style po test.keys test.keys.out | grep -q "Merging" && \
        cat test.keys.out | grep -q "你好，我是keys文件"
    CHECK_RESULT $? 0 0 "option: --keys-style error"
    intltool-merge -s po test.schemas test.schemas.out | grep -q "Merging" && \
        cat test.schemas.out | grep -q "你好，我是schemas文件"
    CHECK_RESULT $? 0 0 "option: -s error"
    rm -rf test.schemas.out
    intltool-merge --schemas-style po test.schemas test.schemas.out | grep -q "Merging" && \
        cat test.schemas.out | grep -q "你好，我是schemas文件"
    CHECK_RESULT $? 0 0 "option: --schemas-style error"
    intltool-merge -r po test.rfc822deb test.rfc822deb.out | grep -q "Merging" && \
        cat test.rfc822deb.out | grep -q "你好，我是rfc822deb文件"
    CHECK_RESULT $? 0 0 "option: -r error"
    rm -rf test.rfc822deb.out
    intltool-merge --rfc822deb-style po test.rfc822deb test.rfc822deb.out | grep -q "Merging" && \
        cat test.rfc822deb.out | grep -q "你好，我是rfc822deb文件"
    CHECK_RESULT $? 0 0 "option: --rfc822deb-style error"
    intltool-merge -x po test.xml test.xml.out | grep -q "Merging" && \
        cat test.xml.out | grep -q "你好，我是xml文件"
    CHECK_RESULT $? 0 0 "option: -x error"
    rm -rf test.xml.out
    intltool-merge --xml-style po test.xml test.xml.out | grep -q "Merging" && \
        cat test.xml.out | grep -q "你好，我是xml文件"
    CHECK_RESULT $? 0 0 "option: --xml-style error"
    intltool-merge -u -r po test.rfc822deb test_utf8.rfc822deb.out | grep -q "Merging" && \
        cat test_utf8.rfc822deb.out | grep -q "你好，我是rfc822deb文件"
    CHECK_RESULT $? 0 0 "option: -u error"
    rm -rf test_utf8.rfc822deb.out
    intltool-merge --utf8 -r po test.rfc822deb test_utf8.rfc822deb.out | grep -q "Merging" && \
        cat test_utf8.rfc822deb.out | grep -q "你好，我是rfc822deb文件"
    CHECK_RESULT $? 0 0 "option: --utf8 error"
    intltool-merge -p -x po test.xml test_pass.xml.out 2>&1 | grep -q "Warning: option --pass-through"
    CHECK_RESULT $? 0 0 "option: -p error"
    intltool-merge --pass-through -x po test.xml test_pass.xml.out 2>&1 | grep -q "Warning: option --pass-through"
    CHECK_RESULT $? 0 0 "option: --pass-through error"
    intltool-merge -m --quoted-style po test.quoted test.quoted.out | grep -q "Merging" && \
        cat merge_test/test.quoted.out | grep -q "你好，我是quoted文件"
    CHECK_RESULT $? 0 0 "option: -m --quoted-style error"
    rm -rf merge_test/test.quoted.out
    intltool-merge --multiple-output --quotedxml-style po test.quotedxml test.quotedxml.out | grep -q "Merging" && \
        cat merge_test/test.quotedxml.out | grep -q "你好，我是quotedxml文件"
    CHECK_RESULT $? 0 0 "option: --multiple-output --quotedxml-style error"
    intltool-merge --no-translations -x test.xml test_no.xml.out | grep -q "Merging" && \
        cat test_no.xml.out | grep -c "<welcome>" | grep -q "1"
    CHECK_RESULT $? 0 0 "option: --no-translations error"
    intltool-merge po/ -x -c po/.intltool-merge-cache test.xml test_cache.xml.out | grep -q "Merging" && \
        cat po/.intltool-merge-cache | grep -q "你好，我是.*文件"
    CHECK_RESULT $? 0 0 "option: -c error"
    rm -rf po/.intltool-merge-cache test_cache.xml.out
    intltool-merge po/ -x --cache=po/.intltool-merge-cache test.xml test_cache.xml.out | grep -q "Merging" && \
        cat po/.intltool-merge-cache | grep -q "你好，我是.*文件"
    CHECK_RESULT $? 0 0 "option: --cache=FILE error"
    intltool-merge -q -k po test.keys test_quiet.keys.out
    CHECK_RESULT $? 0 0 "option: -q error"
    rm -rf test_quiet.keys.out
    intltool-merge --quiet -k po test.keys test_quiet.keys.out
    CHECK_RESULT $? 0 0 "option: --quiet error"

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

