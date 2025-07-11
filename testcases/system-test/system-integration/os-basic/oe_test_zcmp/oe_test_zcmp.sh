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
# @Date      :   2025.6.27
# @License   :   Mulan PSL v2
# @Desc      :   zcmp formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    echo "test1" > testfile_zcmp_1
    echo "test2" > testfile_zcmp_2
    tar -cvf testfile_zcmp_1.tar testfile_zcmp_1
    tar -cvf testfile_zcmp_2.tar testfile_zcmp_2
    tar -cvf testfile_zcmp_3.tar testfile_zcmp_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    zcmp testfile_zcmp_1.tar testfile_zcmp_2.tar
    CHECK_RESULT $? 0 1 "zipgrep error"
    zcmp testfile_zcmp_1.tar testfile_zcmp_3.tar
    CHECK_RESULT $? 0 0 "zipgrep error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_zcmp_1 testfile_zcmp_2 testfile_zcmp_1.tar testfile_zcmp_2.tar testfile_zcmp_3.tar
    LOG_INFO "End to restore the test environment."
}

main "$@"
