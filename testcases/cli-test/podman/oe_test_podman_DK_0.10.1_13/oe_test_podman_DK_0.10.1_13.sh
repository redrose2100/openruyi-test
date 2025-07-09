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
    podman pull ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    version_check
    LOG_INFO "Start to run test."
    ID=$(docker create --log-driver=k8s-file ubi8-minimal ls)
    docker inspect "$ID" | grep -i driver
    CHECK_RESULT $?
    ID=$(docker create --log-opt max-size=10mb ubi8-minimal ls)
    docker inspect "$ID" | grep -i log
    CHECK_RESULT $?
    ID=$(docker create --memory 5MB ubi8-minimal ls)
    docker inspect "$ID" | grep '"Memory": 5242880'
    CHECK_RESULT $?
    ID=$(docker create --memory-reservation 5g ubi8-minimal ls)
    docker inspect "$ID" | grep '"MemoryReservation": 5368709120'
    CHECK_RESULT $?
    ID=$(docker create --memory 2g --memory-swap 4g ubi8-minimal ls)
    docker inspect "$ID" | grep '"MemorySwap": 4294967296'
    CHECK_RESULT $?
    ID=$(docker create --memory-swappiness 4 ubi8-minimal ls)
    docker inspect "$ID" | grep '"MemorySwappiness": 4'
    CHECK_RESULT $?
    touch /tmp/host || exit 1
    mkdir -p /tmp/host
    ID=$(docker create --mount type=bind,source=/tmp/host,destination=/tmp/container ubi8-minimal ls)
    docker inspect "$ID" | grep "/tmp/host"
    CHECK_RESULT $?
    ID=$(docker create --name example ubi8-minimal ls)
    docker inspect "$ID" | grep '"Name": "example"'
    CHECK_RESULT $?
    ID=$(docker create --net bridge ubi8-minimal ls)
    docker inspect "$ID" | grep '"NetworkMode": "bridge"'
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    rm -rf /tmp/host
    LOG_INFO "End to restore the test environment."
}

main "$@"
