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
# @Author    :   duanxuemin
# @Contact   :   duanxuemin@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull postgres:alpine
    podman run --name postgres -e POSTGRES_PASSWORD=secret -d postgres:alpine
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if lscpu | grep -i cpu: | grep 1; then
        LOG_INFO "Insufficient number of CPUs."
    else
        ID=$(docker create --cpuset-cpus 1 alpine ls)
        docker inspect "$ID" | grep -i '"CpuSetCpus": "1"'
        CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i CpuSetCpus failed"
    fi
    ID=$(podman create --cpuset-mems 0 alpine ls)
    podman inspect "$ID" | grep -i '"CpuSetMems": "0"'
    CHECK_RESULT $? 0 0 'check "CpuSetMems": "0" test failed'
    ID=$(podman create alpine ls)
    podman inspect "$ID" | grep -i alpine
    CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i alpine failed"
    ID=$(podman create --device /dev/dm-0 alpine ls)
    podman inspect "$ID" | grep -i '"PathOnHost": "/dev/dm-0"'
    CHECK_RESULT $? 0 0 'check "PathOnHost": "/dev/dm-0" test failed'
    ID=$(podman create --device-read-bps=/dev/:1mb alpine ls)
    podman inspect "$ID" | grep -A 5 -i "BlkioDeviceReadBps"
    CHECK_RESULT $? 0 0 'check BlkioDeviceReadBps test failed'
    ID=$(podman create --device-read-iops=/dev/:1000 alpine ls)
    podman inspect "$ID" | grep -A 5 -i "BlkioDeviceReadIOps"
    CHECK_RESULT $? 0 0 'check BlkioDeviceReadIOps test failed'
    ID=$(podman create --device-write-bps=/dev/:1mb alpine ls)
    podman inspect "$ID" | grep -A 5 -i "BlkioDeviceWriteBps"
    CHECK_RESULT $? 0 0 'check BlkioDeviceWriteBps test failed'
    ID=$(podman create --device-write-iops=/dev/:1000 alpine ls)
    podman inspect "$ID" | grep -A 5 -i "BlkioDeviceWriteIOps"
    CHECK_RESULT $? 0 0 'check BlkioDeviceWriteBps test failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
