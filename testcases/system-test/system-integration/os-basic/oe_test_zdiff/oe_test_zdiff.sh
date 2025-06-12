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
# @Date      :   2025.6.12
# @License   :   Mulan PSL v2
# @Desc      :   zdiff formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "test1" > testfile_zdiff_1
    echo "test2" > testfile_zdiff_2
    zip testfile_zdiff_1.zip testfile_zdiff_1
    zip testfile_zdiff_2.zip testfile_zdiff_2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    zdiff testfile_zdiff_1.zip testfile_zdiff_2.zip
    CHECK_RESULT $? 0 1 "zipgrep error"
    zdiff testfile_zdiff_1.zip testfile_zdiff_1.zip
    CHECK_RESULT $? 0 0 "zipgrep error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_zdiff_1 testfile_zdiff_2 testfile_zdiff_1.zip testfile_zdiff_2.zip
    LOG_INFO "End to restore the test environment."
}

main "$@"
