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
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    tuna show_threads | grep systemd
    CHECK_RESULT $? 0 0 "tuna show_threads No Pass"
    tuna show_threads -U | grep systemd
    CHECK_RESULT $? 0 1 "tuna show_threads -U No Pass"
    tuna show_threads --no_uthreads | grep systemd
    CHECK_RESULT $? 0 1 "tuna show_threads --no_uthreads No Pass"
    tuna show_threads | grep cpu
    CHECK_RESULT $? 0 0 "tuna show_threads No Pass"
    tuna show_threads -K | grep cpu
    CHECK_RESULT $? 0 1 "tuna show_threads -K No Pass"
    tuna show_threads --no_kthreads | grep cpu
    CHECK_RESULT $? 0 1 "tuna show_threads --no_kthreads No Pass"
    tuna show_threads -G | grep "name="
    CHECK_RESULT $? 0 0 "tuna show_threads -G No Pass"
    tuna show_threads --cgroups | grep "name="
    CHECK_RESULT $? 0 0 "tuna show_threads --cgroups No Pass"
    tuna show_threads -z | grep systemd
    CHECK_RESULT $? 0 0 "tuna show_threads -z No Pass"
    tuna show_threads --spaced | grep systemd
    CHECK_RESULT $? 0 0 "tuna show_threads --spaced No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}

main "$@"
