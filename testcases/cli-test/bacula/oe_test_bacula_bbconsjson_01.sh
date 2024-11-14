#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test bconsjson
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "bacula-client bacula-common"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    bbconsjson -? 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "test bbconsjson -? failed"
    bbconsjson -c /etc/bacula/bconsole.conf | grep '"bacula-dir"'
    CHECK_RESULT $? 0 0 "test bbconsjson -c failed"
    bbconsjson -v -d 21 -r Director -c /etc/bacula/bconsole.conf | grep '"bacula-dir"'
    CHECK_RESULT $? 0 0 "test bbconsjson -d failed"
    bbconsjson -v | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bbconsjson -v failed"
    bbconsjson -v -r Director -c /etc/bacula/bconsole.conf | grep 'Address'
    CHECK_RESULT $? 0 0 "test bbconsjson -r failed"
    bbconsjson -v -r Director -n bacula-dir -c /etc/bacula/bconsole.conf | grep 'DirPort'
    CHECK_RESULT $? 0 0 "test bbconsjson -n failed"
    bbconsjson -v -l baucla -r Director -c /etc/bacula/bconsole.conf | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bbconsjson -l failed"
    bbconsjson -v -D -c /etc/bacula/bconsole.conf | grep 'Password'
    CHECK_RESULT $? 0 0 "test bbconsjson -D failed"
    bbconsjson -dt -d 21 -r Director -c /etc/bacula/bconsole.conf | grep 'bacula-dir'
    CHECK_RESULT $? 0 0 "test bbconsjson -dt failed"
    bbconsjson -t -r Director -c /etc/bacula/bconsole.conf
    CHECK_RESULT $? 0 0 "test bbconsjson -t failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=$OLD_LANG
    DNF_REMOVE "$@" 
    rm -rf config/
    LOG_INFO "End to restore the test environment."
}

main "$@"
