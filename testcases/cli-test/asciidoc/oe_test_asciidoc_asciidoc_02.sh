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
# @Desc      :   Take the test asciidoc option
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
    asciidoc --doctest common/test.adoc 2>&1
    CHECK_RESULT $? 0 0 "Check asciidoc --doctest failed"
    for doctype in "article" "book" "manpage"
    do
    	asciidoc -d ${doctype} -o ${TMP_DIR}/test3.pdf common/test.adoc 2>&1 && \
    	test -f ${TMP_DIR}/test3.pdf
    	CHECK_RESULT $? 0 0 "Check asciidoc -d ${doctype} failed"
    	asciidoc --doctype ${doctype} -o ${TMP_DIR}/test4.pdf common/test.adoc 2>&1 && \
    	test -f ${TMP_DIR}/test4.pdf
   	CHECK_RESULT $? 0 0 "Check asciidoc --doctype ${doctype} failed"
    done
    asciidoc -c common/test.adoc 2>&1
    CHECK_RESULT $? 0 0 "Check asciidoc -c failed"
    asciidoc --dump-conf common/test.adoc 2>&1
    CHECK_RESULT $? 0 0 "Check asciidoc --dump-conf failed"
    asciidoc -s -o ${TMP_DIR}/test3.pdf common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test3.pdf
    CHECK_RESULT $? 0 0 "Check asciidoc -s failed"
    asciidoc --no-header-footer -o ${TMP_DIR}/test4.pdf common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test4.pdf
    CHECK_RESULT $? 0 0 "Check asciidoc --no-header-footer failed"
    asciidoc -n -o ${TMP_DIR}/test3.html common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test3.html
    CHECK_RESULT $? 0 0 "Check asciidoc -n failed"
    asciidoc --section-number -o ${TMP_DIR}/test4.html common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test4.html
    CHECK_RESULT $? 0 0 "Check asciidoc --section-number failed"
    asciidoc -v -o ${TMP_DIR}/test3.html common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test3.html
    CHECK_RESULT $? 0 0 "Check asciidoc -v failed"
    asciidoc --verbose -o ${TMP_DIR}/test4.html common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test4.html
    CHECK_RESULT $? 0 0 "Check asciidoc --verbose failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
