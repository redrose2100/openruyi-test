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
    a2x -f xhtml -D ${TMP_DIR}/  --asciidoc-opts="--section-number" common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --asciidoc-opts failed"
    for doctype in "article" "manpage" "book"
    do
    	a2x -f xhtml -d ${doctype} -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    	test -f ${TMP_DIR}/test.html
    	CHECK_RESULT $? 0 0 "Check a2x -d ${doctype} failed"
    	a2x -f xhtml --doctype ${doctype} -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    	test -f ${TMP_DIR}/test.html
    	CHECK_RESULT $? 0 0 "Check a2x --doctype ${doctype} failed"
    done
    a2x -L -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x -L failed"
    a2x --no-xmllint -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --no-xmllint failed"
    a2x -v -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x -v failed"
    a2x --verbose -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --verbose failed"
    a2x -k -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x -k failed"
    a2x -k -f xhtml -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --keep-artifacts failed"
    a2x -f xhtml  --dblatex-opts='--param page.margin.inner=10cm' -D ${TMP_DIR}/ common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.html
    CHECK_RESULT $? 0 0 "Check a2x --dblatex-opts failed"
    a2x --fop -f pdf --fop-opts='-v' -D ${TMP_DIR}/ common/test.adoc | grep "FOP Version"
    test -f ${TMP_DIR}/test.pdf
    CHECK_RESULT $? 0 0 "Check a2x --fop-opts failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
