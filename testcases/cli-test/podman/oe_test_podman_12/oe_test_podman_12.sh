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
# @Date      :   2021/01/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
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
    ID=$(podman create -t -i --name myctr ubi8-minimal ls)
    podman inspect "$ID" | grep '"Name": "myctr"'
    CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i group failed"
    ID=$(podman create --hostname localhost ubi8-minimal ls)
    podman inspect "$ID" | grep '"Hostname": "localhost"'
    CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep -i group failed"
    ID=$(podman create --image-volume bind ubi8-minimal ls)
    podman inspect "$ID" | grep -i bind
    CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep -i bind failed"
    ID=$(podman create --ip "${NODE1_IPV4}" ubi8-minimal ls)
    podman inspect "$ID" | grep -i ip
    CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep -i ip failed"
    ID=$(podman create --ipc host ubi8-minimal ls)
    podman inspect "$ID" | grep '"IpcMode": "host"'
    CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep IpcMode: host failed"
    ID=$(podman create --kernel-memory 1g ubi8-minimal ls)
    podman inspect "$ID" | grep -i "Kernel.*Memory"
    CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep KernelMemory failed"
    ID=$(podman create --label com.example.key=value ubi8-minimal ls)
    podman inspect "$ID" | grep '"com.example.key": "value"'
    CHECK_RESULT $? 0 0 "podman create --label com.example.key=value ubi8-minimal ls failed"
    echo "com.example.key=value" >./a
    ID=$(podman create --label-file ./a ubi8-minimal ls)
    podman inspect "$ID" | grep '"com.example.key": "value"'
    CHECK_RESULT $? 0 0 "podman create --label-file ./a ubi8-minimal ls failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    LOG_INFO "End to restore the test environment."
}

main "$@"
