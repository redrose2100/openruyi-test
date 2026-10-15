#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/01/02
# @License   :   Mulan PSL v2
# @Desc      :   Test "tuna" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "tuna"
    systemctl restart sshd.service
    cp /etc/tuna/example.conf ./
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    tuna apply -h | grep "usage: tuna apply"
    CHECK_RESULT $? 0 0 "tuna apply -h No Pass"
    tuna apply --help | grep "usage: tuna apply"
    CHECK_RESULT $? 0 0 "tuna apply --help No Pass"
    tuna what_is -h | grep "usage: tuna what_is"
    CHECK_RESULT $? 0 0 "tuna what_is -h No Pass"
    tuna what_is --help | grep "usage: tuna what_is"
    CHECK_RESULT $? 0 0 "tuna what_is --help No Pass"
    tuna what_is sshd | grep "sshd:"
    CHECK_RESULT $? 0 0 "tuna what_is No Pass"
    tuna gui -h | grep "usage: tuna gui"
    CHECK_RESULT $? 0 0 "tuna gui -h No Pass"
    tuna gui --help | grep "usage: tuna gui"
    CHECK_RESULT $? 0 0 "tuna gui --help No Pass"
    tuna isolate -h | grep "tuna isolate"
    CHECK_RESULT $? 0 0 "tuna isolate -h No Pass"
    tuna isolate --help | grep "tuna isolate"
    CHECK_RESULT $? 0 0 "tuna isolate --help No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf example.conf
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
