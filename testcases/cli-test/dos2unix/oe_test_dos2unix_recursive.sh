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
# @Date       : 2026-05-14
# @License    : Mulan PSL v2
# @Desc       : Test dos2unix -R -o -c recursive and mode related parameters
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dos2unix
    # Create test dir and test file for recursive test
    mkdir -p /tmp/test_dir
    echo "test content" > /tmp/test_dir/test_rec.txt
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    dos2unix -R /tmp/test_dir > /tmp/recur_R.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -R execute failed"
    [ -f /tmp/test_dir/test_rec.txt ]
    CHECK_RESULT $? 0 0 "file missing after recursive -R operation"

    dos2unix -o /tmp/test_dir/test_rec.txt > /tmp/recur_o.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -o execute failed"
    test -s /tmp/recur_o.log
    CHECK_RESULT $? 0 0 "dos2unix -o output empty"

    dos2unix -c mac /tmp/test_dir/test_rec.txt > /tmp/recur_c.log 2>&1
    CHECK_RESULT $? 0 0 "dos2unix -c execute failed"
    test -s /tmp/recur_c.log
    CHECK_RESULT $? 0 0 "dos2unix -c output empty"

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # shellcheck disable=SC2119
    DNF_REMOVE
    rm -rf /tmp/test_dir /tmp/recur_*.log
    LOG_INFO "Finish restoring the test environment."
}

main "$@"