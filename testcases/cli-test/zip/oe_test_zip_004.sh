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
# @Date      :   2024-07-04
# @License   :   Mulan PSL v2
# @Desc      :   Encrypt and decrypt zip
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    mkdir testdata
    mkdir testdata1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    zip test.zip testdata/
    test -e test.zip
    CHECK_RESULT $? 0 0 "zip is failed!"
    zip -r test.zip . -q
    CHECK_RESULT $? 0 0 "test.zip is failed!"
    unzip -l test.zip
    CHECK_RESULT $? 0 0 "unzip is failed!" 
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf testdata testdata1 test.zip
    LOG_INFO "End to restore the test environment."
}

main "$@"

