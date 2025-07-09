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
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    version_check
    LOG_INFO "Start to run test."
    ID=$(docker create --cpuset-cpus 0 ubi8-minimal ls)
    docker inspect "$ID" | grep -i '"CpuSetCpus": "0"'
    CHECK_RESULT $?
    ID=$(docker create --cpuset-mems 0 ubi8-minimal ls)
    docker inspect "$ID" | grep -i '"CpuSetMems": "0"'
    CHECK_RESULT $?
    ID=$(docker create -d ubi8-minimal ls)
    docker inspect "$ID" | grep ubi8-minimal
    CHECK_RESULT $?
    ID=$(docker create --detach-keys "ctrl-p,ctrl-q" ubi8-minimal ls)
    docker inspect "$ID" | grep -i key
    CHECK_RESULT $?
    ID=$(docker create --device /dev/dm-0 ubi8-minimal ls)
    docker inspect "$ID" | grep -i "/dev/dm-0"
    CHECK_RESULT $?
    ID=$(docker create --device-read-bps=/dev/:1mb ubi8-minimal ls)
    docker inspect "$ID" | grep -i "DeviceReadBps"
    CHECK_RESULT $?
    ID=$(docker create --device-read-iops=/dev/:1000 ubi8-minimal ls)
    docker inspect "$ID" | grep -i "DeviceReadIOps"
    CHECK_RESULT $?
    ID=$(docker create --device-write-bps=/dev/:1mb ubi8-minimal ls)
    docker inspect "$ID" | grep -i "DeviceWriteBps"
    CHECK_RESULT $?
    ID=$(docker create --device-write-iops=/dev/:1000 ubi8-minimal ls)
    docker inspect "$ID" | grep -i "DeviceWriteIOps"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    LOG_INFO "End to restore the test environment."
}

main "$@"
