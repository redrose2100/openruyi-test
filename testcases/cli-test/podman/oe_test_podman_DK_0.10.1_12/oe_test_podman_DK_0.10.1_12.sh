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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create -t -i --name myctr ubi8-minimal ls)
    docker inspect "$ID" | grep '"Name": "myctr"'
    CHECK_RESULT $?
    ID=$(docker create --hostname localhost ubi8-minimal ls)
    docker inspect "$ID" | grep '"Hostname": "localhost"'
    CHECK_RESULT $?
    ID=$(docker create --image-volume bind ubi8-minimal ls)
    docker inspect "$ID" | grep -i bind
    CHECK_RESULT $?
    ID=$(docker create --builtin-volume tmpfs ubi8-minimal ls)
    docker inspect "$ID" | grep -i tmpfs
    CHECK_RESULT $?
    ID=$(docker create --ip "${NODE1_IPV4}" ubi8-minimal ls)
    docker inspect "$ID" | grep -i ip
    CHECK_RESULT $?
    ID=$(docker create --ipc host ubi8-minimal ls)
    docker inspect "$ID" | grep '"IpcMode": "host"'
    CHECK_RESULT $?
    ID=$(docker create --kernel-memory 1g ubi8-minimal ls)
    docker inspect "$ID" | grep '"KernelMemory": 1073741824'
    CHECK_RESULT $?
    ID=$(docker create --label com.example.key=value ubi8-minimal ls)
    docker inspect "$ID" | grep '"com.example.key": "value"'
    CHECK_RESULT $?
    echo "com.example.key=value" >./a
    ID=$(docker create --label-file ./a ubi8-minimal ls)
    docker inspect "$ID" | grep '"com.example.key": "value"'
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
