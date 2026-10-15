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
    tuna show_threads -h | grep "usage: tuna show_threads"
    CHECK_RESULT $? 0 0 "tuna show_threads -h No Pass"
    tuna show_threads --help | grep "usage: tuna show_threads"
    CHECK_RESULT $? 0 0 "tuna show_threads --help No Pass"
    tuna show_threads -c 0 2>&1 | grep "cpu.*0"
    CHECK_RESULT $? 0 0 "tuna show_threads -c No Pass"
    tuna show_threads --cpus 0 2>&1 | grep "cpu.*0"
    CHECK_RESULT $? 0 0 "tuna show_threads --cpus No Pass"
    tuna show_threads -S 0 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "tuna show_threads -S No Pass"
    tuna show_threads --sockets 0 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "tuna show_threads --sockets No Pass"
    tuna show_threads -t sshd | grep sshd
    CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
    tuna show_threads --threads sshd | grep sshd
    CHECK_RESULT $? 0 0 "tuna show_threads --threads No Pass"
    tuna show_threads -q pciehp | grep -E "pciehp|sshd"
    CHECK_RESULT $? 0 0 "tuna show_threads -q No Pass"
    tuna show_threads --irqs pciehp | grep -E "pciehp|sshd"
    CHECK_RESULT $? 0 0 "tuna show_threads --irqs No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
