#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2021/01/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    docker pull registry.access.redhat.com/ubi8-minimal
    docker run --name postgres registry.access.redhat.com/ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker ps --filter name=postgres
    CHECK_RESULT $?
    docker ps -q
    CHECK_RESULT $?
    docker ps -s | grep SIZE
    CHECK_RESULT $?
    docker run --name postgres2 registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $?
    docker ps -a --sort names | awk '{print $NF}' | grep "postgres2"
    CHECK_RESULT $?
    docker ps -a | grep "postgres"
    CHECK_RESULT $?
    docker ps -a --sort names | awk '{print $NF}' | grep "postgres"
    CHECK_RESULT $?
    docker stop postgres2
    CHECK_RESULT $?
    docker rm postgres2
    CHECK_RESULT $?
    docker ps -aq | grep "$(ls /run/crun/ | cut -b 1-12)"
    CHECK_RESULT $?
    docker ps --no-trunc | grep "$(ls /run/crun/)"
    CHECK_RESULT $?
    docker ps --pod | grep "POD"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
