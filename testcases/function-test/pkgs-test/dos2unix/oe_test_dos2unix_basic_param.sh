#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#     http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO NONINFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# PURPOSE.  See the Mulan PSL v2 for more details.
####################################
# @Author     : guoyejin
# @Contact    : guoyejin@uniontech.com
# @Date       : 2026-05-26
# @License    : Mulan PSL v2
# @Desc       : dos2unix -q -v -h -V
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dos2unix
    TESTFILE="/tmp/test_qv.txt"
    echo "test" > "${TESTFILE}"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    dos2unix -q "${TESTFILE}" > /tmp/q.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -q execute failed"
    test ! -s /tmp/q.log
    CHECK_RESULT $? 0 0 "dos2unix -q output not empty, quiet mode abnormal"

    dos2unix -v "${TESTFILE}" > /tmp/v.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -v execute failed"
    test -s /tmp/v.log
    CHECK_RESULT $? 0 0 "dos2unix -v output empty, verbose mode abnormal"

    dos2unix -h > /tmp/h.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -h execute failed"
    test -s /tmp/h.log
    CHECK_RESULT $? 0 0 "dos2unix -h output empty, help info abnormal"

    dos2unix -V > /tmp/ver.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -V execute failed"
    test -s /tmp/ver.log
    CHECK_RESULT $? 0 0 "dos2unix -V output empty, version info abnormal"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf "${TESTFILE}" /tmp/q.log /tmp/v.log /tmp/h.log /tmp/ver.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"