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
# shellcheck disable=SC1091

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(podman create --tmpfs tmpfs ubi8-minimal ls)
    podman inspect "$ID" | grep tmpfs
    CHECK_RESULT $?
    ID=$(podman create --user root ubi8-minimal ls)
    grep '"User":"root"' /var/lib/containers/storage/overlay-containers/"$ID"/userdata/artifacts/create-config
    CHECK_RESULT $?
    ID=$(podman create --userns host ubi8-minimal ls)
    podman inspect "$ID" | grep '"UsernsMode": "host"'
    CHECK_RESULT $?
    ID=$(podman create --uts host ubi8-minimal ls)
    podman inspect "$ID" | grep '"UTSMode": "host"'
    CHECK_RESULT $?
    podman create --name example ubi8-minimal ls
    ID=$(podman create --volume /tmp:/tmp:z ubi8-minimal ls)
    podman inspect "$ID" | grep '"destination": "/tmp"'
    CHECK_RESULT $?
    ID=$(podman create --volumes-from example ubi8-minimal ls)
    grep '"VolumesFrom":\["example"\]' /var/lib/containers/storage/overlay-containers/"$ID"/userdata/artifacts/create-config
    CHECK_RESULT $?
    ID=$(podman create --workdir /tmp ubi8-minimal ls)
    podman inspect "$ID" | grep '"WorkingDir": "/tmp"'
    CHECK_RESULT $?
    podman rmi -f "$(podman images -q)"
    CHECK_RESULT $?
    podman images | grep "ubi8-minimal"
    CHECK_RESULT $? 1
    podman pull ubi8-minimal
    podman images | grep "ubi8-minimal"
    CHECK_RESULT $?
    podman rmi --all
    CHECK_RESULT $?
    podman images | grep "ubi8-minimal"
    CHECK_RESULT $? 1
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
