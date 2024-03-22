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

source "${OET_PATH}/testcases/cli-test/podman/common/common_podman.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull postgres:alpine
    podman run --name postgres -e POSTGRES_PASSWORD=secret -d postgres:alpine
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(podman create --cpuset-cpus 1 alpine ls)
    podman inspect "$ID" | grep -i '"CpuSetCpus": "1"'
    CHECK_RESULT $?
    ID=$(podman create --cpuset-mems 0 alpine ls)
    podman inspect "$ID" | grep -i '"CpuSetMems": "0"'
    CHECK_RESULT $?
    ID=$(podman run -d alpine ls)
    podman inspect "$ID" | grep alpine
    CHECK_RESULT $?
    podman run --detach-keys "ctrl-p,ctrl-q" alpine ls
    ID=$(podman ps -lq)
    podman inspect "$ID" | grep -i key
    CHECK_RESULT $?
    ID=$(podman create --device /dev/dm-0 alpine ls)
    podman inspect "$ID" | grep -i "/dev/dm-0"
    CHECK_RESULT $?
    ID=$(podman create --device-read-bps=/dev/:1mb alpine ls)
    podman inspect "$ID" | grep -iA 5 "Ulimits" | grep 1048576
    CHECK_RESULT $?
    ID=$(podman create --device-read-iops=/dev/:1000 alpine ls)
    podman inspect "$ID" | grep -iA 5 "CreateCommand" | grep 1000
    CHECK_RESULT $?
    ID=$(podman create --device-write-bps=/dev/:1mb alpine ls)
    podman inspect "$ID" | grep -iA 5 "Ulimits" | grep 1048576
    CHECK_RESULT $?
    ID=$(podman create --device-write-iops=/dev/:1000 alpine ls)
    podman inspect "$ID" | grep -iA 5 "CreateCommand" | grep 1000
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
