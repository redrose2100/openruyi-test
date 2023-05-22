#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
#####################################
#@Author    	:   wulei
#@Contact   	:   wulei@uniontech.com
#@Date      	:   2023-05-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Use of Python3Virtualenv
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL 'python3-virtualenv'
    pwddir=$(pwd)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    virtualenv --version | grep 'virtualenv'
    CHECK_RESULT $? 0 0 'Virtualenv version query failed'
    mkdir mydir
    cd mydir || exit
    virtualenv --system-site-packages myenv
    CHECK_RESULT $? 0 0 'Myenv creation failed'
    cd myenv/bin/ || exit
    chmod +x activate
    . ./activate
    CHECK_RESULT $? 0 0 'Failed to use Python 3 virtual environment'
    deactivate
    CHECK_RESULT $? 0 0 'Failed to exit the Python 3 virtual environment'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd "$pwddir" || exit
    rm -rf mydir
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
