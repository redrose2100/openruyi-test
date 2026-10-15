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
# shellcheck disable=SC1091,SC2119

source "../common/common_podman.sh"
source "../common/versioncheck.sh"


function pre_test() {
    version_check
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    version_check
    LOG_INFO "Start to run test."
    ID=$(docker create --cgroup-parent machine.slice ubi8-minimal ls)
    docker inspect "$ID" | grep '"CgroupParent": "machine.slice"'
    CHECK_RESULT $?
    ID=$(docker create --cidfile cidfile ubi8-minimal ls)
    grep "$ID" cidfile
    CHECK_RESULT $?
    ID=$(docker create --conmon-pidfile ./ ubi8-minimal ls)
    docker inspect "$ID" | grep "$ID"
    CHECK_RESULT $?
    ID=$(docker create --cpu-period 10000 ubi8-minimal ls)
    docker inspect "$ID" | grep '"CpuPeriod": 10000'
    CHECK_RESULT $?
    ID=$(docker create --cpu-quota 1001 ubi8-minimal ls)
    docker inspect "$ID" | grep '"CpuQuota": 1001'
    CHECK_RESULT $?
    ID=$(docker create --cpu-rt-period 1 ubi8-minimal ls)
    docker inspect "$ID" | grep '"CpuRealtimePeriod": 1'
    CHECK_RESULT $?
    ID=$(docker create --cpu-rt-runtime 2 ubi8-minimal ls)
    docker inspect "$ID" | grep '"CpuRealtimeRuntime": 2'
    CHECK_RESULT $?
    ID=$(docker create --cpu-shares 3 ubi8-minimal ls)
    docker inspect "$ID" | grep '"CpuShares": 3'
    CHECK_RESULT $?
    ID=$(docker create --cpus 4 ubi8-minimal ls)
    docker inspect "$ID" | grep '"CpuQuota": 400000'
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    rm -rf cidfile
    LOG_INFO "End to restore the test environment."
}

main "$@"
