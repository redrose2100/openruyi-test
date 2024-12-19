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
# @Contact   :   duanxuemin25812@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    docker pull ubi8-minimal
    docker run --name postgres -e POSTGRES_PASSWORD=secret -d ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker help | grep -E "docker|help"
    CHECK_RESULT $? 0 0 'check docker help | grep -E "docker|help" failed'
    docker create ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker create ubi8-minimal failed'
    docker ps -a | grep -i "Created"
    CHECK_RESULT $? 0 0 'check docker ps -a | grep -i "Created" failed'
    ID=$(docker create --annotation HELLO=WORLD ubi8-minimal)
    docker inspect "$ID" | grep '"HELLO": "WORLD"'
    CHECK_RESULT $? 0 0 "check docker inspect $ID | grep failed"
    docker create --attach STDIN ubi8-minimal ls
    CHECK_RESULT $? 0 0 'check docker create --attach STDIN ubi8-minimal ls failed'
    docker ps -a | grep ls
    CHECK_RESULT $? 0 0 'check docker ps -a | grep ls faield'
    podman_version=$(rpm -qa podman | awk -F- '{print $2}' | awk -F. '{print $1$2$3}')
    if [ "$podman_version" -gt 400 ]; then
        ID=$(docker create --blkio-weight 15 ubi8-minimal ls)
        docker inspect "$ID" | grep -i "Blkio.*Weight"
        CHECK_RESULT $? 0 0 'check "BlkioWeight": 15 test failed'
        ID=$(docker create --blkio-weight-device /dev/:15 fedora ls)
        docker inspect "$ID" | grep "weight"
        CHECK_RESULT $? 0 0 'check "weight": 15 test failed'
    else
        LOG_INFO "This version does not have this parameter."
    fi
    ID=$(docker create --cap-add net_admin ubi8-minimal ls)
    docker inspect "$ID" | grep -A 1 "Add" | grep -i "net_admin"
    CHECK_RESULT $? 0 0 'check net_admin test failed'
    ID=$(docker create --cap-drop net_admin ubi8-minimal ls)
    docker inspect "$ID" | grep -iA 1 "Drop" | grep -i "net_admin"
    CHECK_RESULT $? 0 0 'check CapDrop test failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
