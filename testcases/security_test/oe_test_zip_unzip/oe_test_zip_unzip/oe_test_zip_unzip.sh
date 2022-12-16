#!/usr/bin/bashi

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022-12-16
# @License   :   Mulan PSL v2
# @Desc      :   package zip&unzip test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL zip
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    mkdir -p test/test2
    CHECK_RESULT $? 0 0 "mkdir -p test/test2 No error message returned"   
    zip test.zip test/test2
    CHECK_RESULT $? 0 0 "zip test.zip No error message"
    ls
    CHECK_RESULT $? 0 0 "ls existence test.zip"
    rm -rf test
    CHECK_RESULT $? 0 0 "rm -rf test No abnormal information"
    unzip test.zip
    CHECK_RESULT $? 0 0 "No abnormal information returned"
    ls
    CHECK_RESULT $? 0 0 "ls The test directory exists"
    zip --help
    CHECK_RESULT $? 0 0 "zip --help Back to help"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.zip
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@

