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
# @Date      :   2024.3.7
# @License   :   Mulan PSL v2
# @Desc      :   nl formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch testfile_nl
    cat > testfile_nl << EOF
test_one
test_two


EOF
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nl testfile_nl
    CHECK_RESULT $? 0 0 "nl  print error"
    nl testfile_nl |grep test_one |grep 1
    CHECK_RESULT $? 0 0 "nl  print error"
    nl testfile_nl |grep test_two |grep 2
    CHECK_RESULT $? 0 0 "nl  print error"
    nl testfile_nl |grep 3
    CHECK_RESULT $? 1 0 "nl  print error"
    nl testfile_nl |grep 4
    CHECK_RESULT $? 1 0 "nl  print error"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_nl
    LOG_INFO "End to restore the test environment."
}

main "$@"
