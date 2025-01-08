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
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    tuna spread -h | grep "usage: tuna spread"
    CHECK_RESULT $? 0 0 "tuna spread -h No Pass"
    tuna spread --help | grep "usage: tuna spread"
    CHECK_RESULT $? 0 0 "tuna spread --help No Pass"
    irqs_id=$(tuna show_irqs | awk '{print$1}' | tail -n 1)
    tuna spread -c 0 -q "$irqs_id"
    CHECK_RESULT $? 0 0 "tuna spread -c -q No Pass"
    tuna show_irqs -q "$irqs_id" | grep "$irqs_id" | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
    tuna spread -S 0 --irqs "$irqs_id"
    CHECK_RESULT $? 0 0 "tuna spread -S --irqs No Pass"
    tuna show_irqs -q "$irqs_id" | grep "$irqs_id" | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
    tuna spread --cpus 0 -t sshd
    CHECK_RESULT $? 0 0 "tuna spread -cpus -t No Pass"
    tuna show_threads -t sshd | grep sshd | awk '{print $4}' | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
    tuna spread --sockets 0 --threads sshd
    CHECK_RESULT $? 0 0 "tuna spread --sockets --threads No Pass"
    tuna show_threads -t sshd | grep sshd | awk '{print $4}' | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
    tuna priority -h | grep "usage: tuna priority"
    CHECK_RESULT $? 0 0 "tuna priority -h No Pass"
    tuna priority --help | grep "usage: tuna priority"
    CHECK_RESULT $? 0 0 "tuna priority --help No Pass"
    tuna priority -t sshd -C OTHER:0
    CHECK_RESULT $? 0 0 "tuna priority -t -C No Pass"
    tuna show_threads -t sshd | grep OTHER
    CHECK_RESULT $? 0 0 "tuna show_threads -t sshd No Pass"
    tuna priority --threads sshd --affect_children OTHER:0
    CHECK_RESULT $? 0 0 "tuna priority -t -C No Pass"
    tuna show_threads -t sshd | grep OTHER
    CHECK_RESULT $? 0 0 "tuna show_threads -t sshd No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
