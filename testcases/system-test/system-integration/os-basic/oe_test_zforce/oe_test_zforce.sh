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
# @Date      :   2025.5.29
# @License   :   Mulan PSL v2
# @Desc      :   zforce formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    touch testfile_zforce
    echo "This is test for zforce" > testfile_zforce
    tar -czvf testfile_zforce.tar testfile_zforce
    zip testfile_zforce.zip testfile_zforce
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    zforce testfile_zforce.tar
    CHECK_RESULT $? 0 0 "zforce error"
    zforce testfile_zforce.zip
    CHECK_RESULT $? 0 0 "zforce error"
    ls testfile_zforce.tar.gz
    CHECK_RESULT $? 0 0 "zforce error"
    ls testfile_zforce.zip.gz
    CHECK_RESULT $? 0 0 "zforce error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f testfile_zforce
    rm -f testfile_zforce.tar
    rm -f testfile_zforce.zip
    rm -f testfile_zforce.tar.gz
    rm -f testfile_zforce.zip.gz
    LOG_INFO "End to restore the test environment."
}

main "$@"
