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
    podman pull ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create --oom-kill-disable ubi8-minimal ls)
    docker inspect "$ID" | grep '"OomKillDisable": true'
    CHECK_RESULT $?
    ID=$(docker create --oom-score-adj 100 ubi8-minimal ls)
    docker inspect "$ID" | grep '"OomScoreAdj": 100'
    CHECK_RESULT $?
    ID=$(docker create --pid host ubi8-minimal ls)
    docker inspect "$ID" | grep '"PidMode": "host"'
    CHECK_RESULT $?
    ID=$(docker create --pids-limit 3 ubi8-minimal ls)
    docker inspect "$ID" | grep '"PidsLimit": 3'
    CHECK_RESULT $?
    docker pod create --infra=false
    ID=$(docker create --pod "$(podman pod list -lq)" ubi8-minimal ls)
    docker rm "$ID"
    CHECK_RESULT $?
    docker pod rm "$(docker pod list -q)"
    ID=$(docker create --privileged ubi8-minimal ls)
    docker inspect "$ID" | grep '"Privileged": true'
    CHECK_RESULT $?
    ID=$(docker create --publish 23 ubi8-minimal ls)
    docker inspect "$ID" | grep "23"
    CHECK_RESULT $?
    ID=$(docker create --publish-all ubi8-minimal ls)
    docker inspect "$ID" | grep '"PublishAllPorts": false'
    CHECK_RESULT $?
    docker create -q ubi8-minimal ls
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
