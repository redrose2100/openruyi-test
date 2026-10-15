#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You may use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NONINFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author     : guoyejin
# @Contact    : guoyejin@uniontech.com
# @Date       : 2026-05-27
# @License    : Mulan PSL v2
# @Desc       : Test dos2unix -i -u -m file info parameters
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dos2unix
    TESTFILE="/tmp/info_file.txt"
    echo "test content" > "${TESTFILE}"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    dos2unix -i "${TESTFILE}" > /tmp/info_i.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -i execute failed"
    test -s /tmp/info_i.log
    CHECK_RESULT $? 0 0 "dos2unix -i output empty"

    dos2unix -u "${TESTFILE}" > /tmp/info_u.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -u execute failed"
    [ -f /tmp/info_file.txt ]
    CHECK_RESULT $? 0 0 "test file missing after -u convert"

    dos2unix -m "${TESTFILE}" > /tmp/info_m.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -m execute failed"
    test -s /tmp/info_m.log
    CHECK_RESULT $? 0 0 "dos2unix -m output empty"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf "${TESTFILE}" /tmp/info_*.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"