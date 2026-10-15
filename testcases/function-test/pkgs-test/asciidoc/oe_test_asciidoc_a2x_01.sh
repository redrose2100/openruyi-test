#!/usr/bin/bash

# Copyright (c) 2023. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   yangshicheng
# @Contact   :   scyang_zjut@163.com
# @Date      :   2023/04/12
# @License   :   Mulan PSL v2
# @Desc      :   Take the test a2x option
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TMP_DIR="./tmp"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "asciidoc fop"
    mkdir $TMP_DIR
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    a2x -h | grep "a2x"
    CHECK_RESULT $? 0 0 "Check a2x -h failed"
    a2x --help | grep "a2x"
    CHECK_RESULT $? 0 0 "Check a2x --help failed"
    a2x --version | grep "a2x $(rpm -qa | grep asciidoc | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "Check a2x --version failed"
    a2x -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x -D failed"
    a2x -f xhtml --destination-dir ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --destination-dir failed"
    a2x --fop -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.pdf
    CHECK_RESULT $? 0 0 "Check a2x --fop failed"
    a2x --fop -D ${TMP_DIR}/ -a max-width=55em common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.pdf
    CHECK_RESULT $? 0 0 "Check a2x -a failed"
    a2x --fop -D ${TMP_DIR}/ --attribute max-width=55em common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.pdf
    CHECK_RESULT $? 0 0 "Check a2x --attribute failed"
    a2x -n -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x -n failed"
    a2x -n -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --dry-run failed"
    a2x --lynx -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --lynx failed"
    a2x -f xhtml --stylesheet docbook-xsl.css -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --stylesheet failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
