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
#@Desc          :   command test-rinetd
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "rinetd"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rinetd --help | grep Usage
    CHECK_RESULT $?
    rinetd -h | grep Usage
    CHECK_RESULT $?
    rinetd --version | grep rinetd
    CHECK_RESULT $?
    rinetd -v | grep rinetd
    CHECK_RESULT $?
    touch /etc/rinetd.conf
    rinetd -c /etc/rinetd.conf
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/rinetd.conf
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

