#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

####################################
# @Author    	:   guoyejin
# @Contact   	:   guoyejin@uniontech.com
# @Date      	:   2026-05-28
# @License   	:   Mulan PSL v2
# @Desc      	:   Test dos2unix -n -k parameter function
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dos2unix
    TESTFILE="/tmp/test_src.txt"
    NEWFILE="/tmp/test_dst.txt"
    echo "test content" > "${TESTFILE}"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    dos2unix -n "${TESTFILE}" "${NEWFILE}" > /tmp/n.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -n execute failed"
    test -f "${NEWFILE}"
    CHECK_RESULT $? 0 0 "dos2unix -n new file not generated"

    BEFORE_TIME=$(stat -c %Y "${TESTFILE}")
    dos2unix -k "${TESTFILE}" > /tmp/k.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -k execute failed"
    AFTER_TIME=$(stat -c %Y "${TESTFILE}")
    [ "${BEFORE_TIME}" -eq "${AFTER_TIME}" ]
    CHECK_RESULT $? 0 0 "dos2unix -k timestamp changed abnormally"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf /tmp/test_src.txt /tmp/test_dst.txt /tmp/n.log /tmp/k.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"