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
# @Author    :   Liwengai
# @Contact   :   liwengai@foxmail.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST hangul
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    test -d tmp || mkdir tmp
    echo "gksrmfdlqfur" > ${TMP_DIR}/test-1.in
    echo "kljingj" > ${TMP_DIR}/test-2.in
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libhangul"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    hangul --help | grep -q "Usage: hangul"
    CHECK_RESULT $? 0 0 "options: --help error"
    hangul --version | grep -q "hangul (libhangul)"
    CHECK_RESULT $? 0 0 "options: --version error"
    hangul -l | grep -q "Sebeolsik"
    CHECK_RESULT $? 0 0 "options: -l error"
    hangul --list | grep -q "Sebeolsik"
    CHECK_RESULT $? 0 0 "options: --list error"
    hangul < ${TMP_DIR}/test-1.in | grep -q "한글입력"
    CHECK_RESULT $? 0 0 "hangul STDIN error"
    hangul ${TMP_DIR}/test-1.in | grep -q "한글입력"
    CHECK_RESULT $? 0 0 "hangul FILEIN error"
    hangul -i "gksrmfdlqfur" | grep -q "한글입력"
    CHECK_RESULT $? 0 0 "options: -i error"
    hangul --input="gksrmfdlqfur" | grep -q "한글입력"
    CHECK_RESULT $? 0 0 "options: --input=STRING error"
    hangul -o ${TMP_DIR}/test-1_1.out < ${TMP_DIR}/test-1.in
    grep -q "한글입력" < ${TMP_DIR}/test-1_1.out
    CHECK_RESULT $? 0 0 "options: -o error"
    hangul --output=${TMP_DIR}/test-1_2.out < ${TMP_DIR}/test-1.in
    grep -q "한글입력" < ${TMP_DIR}/test-1_2.out
    CHECK_RESULT $? 0 0 "options: --output=FILE error"
    hangul -k 3y < ${TMP_DIR}/test-1.in | grep -q "근해잿다ㅐ"
    CHECK_RESULT $? 0 0 "options: -k error"
    hangul --keyboard=3y < ${TMP_DIR}/test-1.in | grep -q "근해잿다ㅐ"
    CHECK_RESULT $? 0 0 "options: --keyboard error"
    hangul -s < ${TMP_DIR}/test-2.in | grep -q "ㅏㅣㅓㅑㅜ허"
    CHECK_RESULT $? 0 0 "options: -s error"
    hangul --strict-order < ${TMP_DIR}/test-2.in | grep -q "ㅏㅣㅓㅑㅜ허"
    CHECK_RESULT $? 0 0 "options: --strict-order error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_FILE}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"