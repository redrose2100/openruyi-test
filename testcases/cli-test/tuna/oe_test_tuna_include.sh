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
    tuna include -h | grep "usage: tuna include"
    CHECK_RESULT $? 0 0 "tuna include -h No Pass"
    tuna include --help | grep "usage: tuna include"
    CHECK_RESULT $? 0 0 "tuna include --help No Pass"
    tuna include -c 0
    CHECK_RESULT $? 0 0 "tuna include -c No Pass"
    tuna include --cpus 0
    CHECK_RESULT $? 0 0 "tuna include --cpus No Pass"
    tuna include -S 0
    CHECK_RESULT $? 0 0 "tuna include -S No Pass"
    tuna include --sockets 0
    CHECK_RESULT $? 0 0 "tuna include --sockets No Pass"
    tuna move -h | grep "usage: tuna move"
    CHECK_RESULT $? 0 0 "tuna move -h No Pass"
    tuna move --help | grep "usage: tuna move"
    CHECK_RESULT $? 0 0 "tuna move --help No Pass"
    irqs_id=$(tuna show_irqs | awk '{print$1}' | tail -n 1)
    tuna move -c 0 -q "${irqs_id}"
    CHECK_RESULT $? 0 0 "tuna move -c -q No Pass"
    tuna show_irqs -q "${irqs_id}" | grep "${irqs_id}" | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
    tuna move -S 0 --irqs "${irqs_id}"
    CHECK_RESULT $? 0 0 "tuna move -S --irqs No Pass"
    tuna show_irqs -q "${irqs_id}" | grep "${irqs_id}" | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
    tuna move --cpus 0 -t sshd
    CHECK_RESULT $? 0 0 "tuna move --cpus -t No Pass"
    tuna show_threads -t sshd | grep sshd | awk '{print $4}' | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
    tuna move --sockets 0 --threads sshd
    CHECK_RESULT $? 0 0 "tuna move --sockets --threads No Pass"
    tuna show_threads -t sshd | grep sshd | awk '{print $4}' | grep -w 0
    CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
