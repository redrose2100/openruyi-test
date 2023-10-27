#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   sunqingwei
#@Contact   :   sunqingwei@uniontech.com
#@Date      :   2023/10/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "crontabs" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    rm -rf /tmp/test.txt
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    hour_date=$(date -d +2min +%H)
    min_date=$(date -d +2min +%M)
    echo -e "$min_date $hour_date * * * echo 'CrontabTest' >> /tmp/test.txt" > /tmp/task.txt
    systemctl restart crond
    CHECK_RESULT $? 0 0 "Service startup failure"
    crontab /tmp/task.txt
    crontab -l | grep "echo 'CrontabTest' >> /tmp/test.txt"
    CHECK_RESULT $? 0 0 "Task creation failure"
    sleep 120
    grep 'CrontabTest' /tmp/test.txt
    CHECK_RESULT $? 0 0 "Task execution failure"
    echo "n" | crontab -ir
    crontab -l | grep "echo 'CrontabTest' >> /tmp/test.txt"
    CHECK_RESULT $? 0 0 "Command execution failure"
    echo "y" | crontab -ir
    crontab -l 2>&1 | grep 'no crontab'
    CHECK_RESULT $? 0 0 "Task deletion failure"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test.txt /tmp/task.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
