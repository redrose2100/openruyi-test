#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhaozhenyang
# @Contact   :   zhaozhenyang@uniontech.com
# @Date      :   2024-05-07
# @License   :   Mulan PSL v2
# @Desc      :   Encrypt and decrypt zip
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    mkdir testdata
    touch test.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    zip  testdatabak.zip testdata
    test -e testdatabak.zip
    CHECK_RESULT $? 0 0 "zip is failed!"
    zip -u testdatabak.zip test.txt
    CHECK_RESULT $? 0 0 "testdatabak.zip is failed!"
    zip -T testdatabak.zip
    CHECK_RESULT $? 0 0 "unzip is failed!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf testdata testdatabak.zip
    LOG_INFO "End to restore the test environment."
}

main "$@"
