#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2021-09-07
#@License       :   Mulan PSL v2
#@Desc          :   command test-ranger
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "ranger"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ranger --help | grep Usage
    CHECK_RESULT $?
    ranger -h | grep Usage 
    CHECK_RESULT $?
    ranger --version | grep "ranger version"
    CHECK_RESULT $?

    rifle --help | grep Usage 
    CHECK_RESULT $?
    rifle -h | grep Usage
    CHECK_RESULT $?
    rifle --version | grep rifle
    CHECK_RESULT $? 
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf *.log
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
