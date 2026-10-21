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
    asciidoc -h manpage | grep "OPTIONS"
    CHECK_RESULT $? 0 0 "Check asciidoc -h manpage failed"
    asciidoc --help manpage | grep "OPTIONS"
    CHECK_RESULT $? 0 0 "Check asciidoc --help manpage failed"
    asciidoc -h syntax | grep "Syntax"
    CHECK_RESULT $? 0 0 "Check asciidoc -h syntax failed"
    asciidoc --help syntax | grep "Syntax"
    CHECK_RESULT $? 0 0 "Check asciidoc --help syntax failed"
    asciidoc --version | grep "asciidoc $(rpm -qa | grep asciidoc | awk -F '-' '{print $2}')"
    CHECK_RESULT $? 0 0 "Check asciidoc --version failed"
    asciidoc -o ${TMP_DIR}/test.pdf -a max-width=55em common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.pdf
    CHECK_RESULT $? 0 0 "Check asciidoc -a failed"
    asciidoc -o ${TMP_DIR}/test.pdf --attribute max-width=55em common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test.pdf
    CHECK_RESULT $? 0 0 "Check asciidoc --attribute failed"
    asciidoc -o ${TMP_DIR}/test1.pdf common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test1.pdf
    CHECK_RESULT $? 0 0 "Check asciidoc -o failed"
    asciidoc --out-file ${TMP_DIR}/test2.pdf common/test.adoc 2>&1 && \
    test -f ${TMP_DIR}/test2.pdf
    CHECK_RESULT $? 0 0 "Check asciidoc --out-file failed"
    for backend in "html4" "xhtml11" "docbook45"
    do
    	asciidoc -b ${backend} -o ${TMP_DIR}/test3.pdf common/test.adoc 2>&1 && \
    	test -f ${TMP_DIR}/test3.pdf
        CHECK_RESULT $? 0 0 "Check asciidoc -b ${backend} failed"
        asciidoc --backend ${backend} -o ${TMP_DIR}/test4.pdf common/test.adoc 2>&1 && \
        test -f ${TMP_DIR}/test4.pdf
        CHECK_RESULT $? 0 0 "Check asciidoc --backend ${backend} failed"
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
