#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.5.21
# @License   :   Mulan PSL v2
# @Desc      :   zipgrep formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch testfile_zipgrep
    cat > testfile_zipgrep << EOF
test_1
Test_2
EOF
    zip testfile_zipgrep.zip testfile_zipgrep
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    res1=$(zipgrep "test_1" testfile_zipgrep.zip)
    [ "$res1" == "testfile_zipgrep:test_1" ]
    CHECK_RESULT $? 0 0 "zipgrep error"
    res2=$(zipgrep -i "test_2" testfile_zipgrep.zip)
    [ "$res2" == "testfile_zipgrep:Test_2" ]
    CHECK_RESULT $? 0 0 "zipgrep error"
    zipgrep -n "Test_2" testfile_zipgrep.zip | grep -q "testfile_zipgrep:2:Test_2"
    CHECK_RESULT $? 0 0 "Line number display failed"
    zipgrep -c "test" testfile_zipgrep.zip | awk -F: '{print $2}' | grep 1
    CHECK_RESULT $? 0 0 "count failed"
    zipgrep -n  testfile_zipgrep.zip | wc -l | grep -q 2
    CHECK_RESULT $? 0 0 "Empty pattern should match all lines"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_zipgrep.zip testfile_zipgrep
    LOG_INFO "End to restore the test environment."
}

main "$@"
