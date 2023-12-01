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
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST pod2markdown
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    mkdir -p ./tmp
    TMP_DIR="./tmp"
    echo "=encoding ascii

=head1 head
this is text in head
ABCDEFGHIJK lmnopqrstuvwxyz
1234567890 ! @ # $ % ^ & *
©  E<copy>
<p> This is some text in a very short paragraph </p>
=cut" > ${TMP_DIR}/test.pod
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "perl-Pod-Markdown"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    pod2markdown -h | grep "Usage"
    CHECK_RESULT $? 0 0 "pod2markdown help error"
    pod2markdown ${TMP_DIR}/test.pod | grep "# head"
    CHECK_RESULT $? 0 0 "option: STDIO error"
    pod2markdown ${TMP_DIR}/test.pod ${TMP_DIR}/test_FIO.out
    grep "# head" ${TMP_DIR}/test_FIO.out
    CHECK_RESULT $? 0 0 "option: FILEIO error"
    pod2markdown - ${TMP_DIR}/test_SIFO.out < ${TMP_DIR}/test.pod
    grep "# head" ${TMP_DIR}/test_SIFO.out
    CHECK_RESULT $? 0 0 "option: STDIN FILEOUT error"
    pod2markdown -u ${TMP_DIR}/test.pod | grep "this is text"
    CHECK_RESULT $? 0 0 "option: -u error"
    pod2markdown --utf8 ${TMP_DIR}/test.pod | grep "this is text"
    CHECK_RESULT $? 0 0 "option: --utf8 error"
    pod2markdown -e ascii ${TMP_DIR}/test.pod | grep "&copy"
    CHECK_RESULT $? 0 0 "option: -e error"
    pod2markdown --output-encoding ascii ${TMP_DIR}/test.pod | grep "&copy"
    CHECK_RESULT $? 0 0 "option: --output-encoding error"
    pod2markdown -m ${TMP_DIR}/test.pod | grep "&copy"
    CHECK_RESULT $? 0 0 "option: -m error"
    pod2markdown --match-encoding ${TMP_DIR}/test.pod | grep "&copy"
    CHECK_RESULT $? 0 0 "option: --match-encoding error"
    pod2markdown --html-encode-chars 1 ${TMP_DIR}/test.pod | grep "/p&gt;"
    CHECK_RESULT $? 0 0 "command --html-encode-chars 1"
    pod2markdown --html-encode-chars ! ${TMP_DIR}/test.pod | grep -E "&#33;|&#x21;"
    CHECK_RESULT $? 0 0 "command --html-encode-chars <char>"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
