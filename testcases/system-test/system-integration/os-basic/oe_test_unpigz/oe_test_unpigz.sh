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
# @Date      :   2025.10.27
# @License   :   Mulan PSL v2
# @Desc      :   unpigz formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment." 
    echo "This is a testfile for unpigz" > testfile_unpigz
    gzip testfile_unpigz
    rm -f testfile_unpigz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    unpigz testfile_unpigz.gz
    CHECK_RESULT $? 0 0 "unpigz error"
    ls testfile_unpigz
    CHECK_RESULT $? 0 0 "unpigz error"
    res1=$(cat testfile_unpigz)
    [ "$res1" == "This is a testfile for unpigz" ]
    CHECK_RESULT $? 0 0 "unpigz error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_unpigz testfile_unpigz.gz
    LOG_INFO "End to restore the test environment."
}

main "$@"
