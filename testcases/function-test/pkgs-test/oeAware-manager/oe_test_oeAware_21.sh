#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   linqian
#@Contact       :   1179362010@qq.com
#@Date          :   2024-06-15
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oeAware-manager"
    systemctl start oeaware
    echo -e "while true; do\n   oeawarectl -q\ndone" >test.sh
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup sh test.sh >test.log 2>&1 & echo $! >test.pid
    SLEEP_WAIT 5 "systemctl restart oeaware"
    SLEEP_WAIT 5
    grep -F "can't connect to server" test.log
    CHECK_RESULT $? 0 0 "failed to disconnect to server"
    oeawarectl -q | grep "Show plugins and instances status"
    CHECK_RESULT $? 0 0 "oeaware service not restored"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    kill -9 "$(cat test.pid)"
    rm -rf test.sh test.log test.pid
    LOG_INFO "End to restore the test environment."
}

main "$@"
