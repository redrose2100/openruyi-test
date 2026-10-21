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
# @Date      :   2024-08-01
# @License   :   Mulan PSL v2
# @Desc      :   Encrypt and decrypt zip
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    touch test1.txt test2.txt test3.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    zip test.zip test1.txt test2.txt
    test -e test.zip
    CHECK_RESULT $? 0 0 "zip is failed!"
    zip -d test.zip test1.txt
    CHECK_RESULT $? 0 0 "test.zip is failed!"
    zip -m test.zip test3.txt
    CHECK_RESULT $? 0 0 "zip -m is failed!" 
    zip -h2
    CHECK_RESULT $? 0 0 "zip -h2 failed!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test1.txt test2.txt test3.txt  test.zip
    LOG_INFO "End to restore the test environment."
}

main "$@"

