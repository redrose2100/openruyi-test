#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangxu
# @Contact   :   zhangxu4@uniontech.com
# @Date      :   2025/06.17
# @License   :   Mulan PSL v2
# @Desc      :   package activemq test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "activemq"
    cd /usr/share/activemq/bin || exit
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test for ActiveMQ proxy."
    ./activemq start proxy
    CHECK_RESULT $? 0 0 "ActiveMQ proxy startup failed"
    SLEEP_WAIT 10
    ./activemq status
    CHECK_RESULT $? 0 0 "ActiveMQ proxy state is not active"
    netstat -anp | grep 8161
    CHECK_RESULT $? 0 0 "Failed to listen to port information"
    curl http://localhost:8161
    CHECK_RESULT $? 0 0 "Web page access failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
