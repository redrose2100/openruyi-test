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
# @Desc      :   The usage of commands in docker package
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create --read-only ubi8-minimal ls)
    docker inspect "$ID" | grep '"ReadonlyRootfs": true'
    CHECK_RESULT $? 0 0 'check ReadonlyRootfs failed'
    docker create --rm ubi8-minimal ls
    CHECK_RESULT $? 0 0 'check docker create --rm ubi8-minimal ls failed'
    ID=$(docker create --security-opt apparmor=unconfined ubi8-minimal ls)
    docker inspect "$ID" | grep 'apparmor=unconfined'
    CHECK_RESULT $? 0 0 'check apparmor=unconfined failed'
    ID=$(docker create --shm-size 65536k ubi8-minimal ls)
    docker inspect "$ID" | grep -i "Shm.*Size"
    CHECK_RESULT $? 0 0 'check ShmSize: 65536000 failed'
    ID=$(docker create --stop-signal 20 ubi8-minimal ls)
    docker inspect "$ID" | grep '"StopSignal": 20'
    CHECK_RESULT $? 0 0 'check StopSignal failed'
    docker create --stop-timeout 10 ubi8-minimal ls
    CHECK_RESULT $? 0 0 'check docker create --stop-timeout 10 ubi8-minimal ls failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    LOG_INFO "End to restore the test environment."
}

main "$@"
