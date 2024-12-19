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
# @Desc      :   The usage of commands in docker package
# ############################################
# shellcheck disable=SC1091

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull ubi8-minimal
    podman run --name postgres -e POSTGRES_PASSWORD=secret -td ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker stop postgres
    docker wait --latest | grep -E "[0-9]"
    CHECK_RESULT $?
    docker wait --interval 250 postgres | grep -E "[0-9]"
    CHECK_RESULT $?
    docker start postgres
    docker kill -l
    CHECK_RESULT $?
    docker ps -a | grep "Exited"
    CHECK_RESULT $?
    docker start postgres
    docker kill -a
    CHECK_RESULT $?
    docker ps -a | grep "Exited"
    CHECK_RESULT $?
    docker start postgres
    docker kill -s KILL "$(docker ps -q)"
    CHECK_RESULT $?
    docker ps -a | grep "Exited"
    CHECK_RESULT $?
    docker start postgres
    docker diff ubi8-minimal | grep -E "C|A"
    CHECK_RESULT $?
    docker diff --format json ubi8-minimal | grep -E "changed|added"
    CHECK_RESULT $?
    docker version | grep "$(rpm -qa docker | awk -F "-" '{print $2}')"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
