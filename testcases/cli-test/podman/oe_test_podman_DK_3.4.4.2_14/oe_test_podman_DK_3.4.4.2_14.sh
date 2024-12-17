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
# shellcheck disable=SC1091,2046

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(docker create --oom-kill-disable registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep '"OomKillDisable": true'
    CHECK_RESULT $? 0 0 "check OomKillDisable failed"
    ID=$(docker create --oom-score-adj 100 registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep '"OomKillDisable":'
    CHECK_RESULT $? 0 0 "check OomKillDisable failed"
    ID=$(docker create --pid host registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep '"PidMode": "host"'
    CHECK_RESULT $? 0 0 "check PidMode host failed"
    ID=$(docker create --pids-limit 3 registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep '"PidsLimit": 3'
    CHECK_RESULT $? 0 0 "check PidsLimit failed"
    docker pod create --infra=false
    ID=$(docker create --pod $(docker pod list -lq) registry.access.redhat.com/ubi8-minimal ls)
    docker rm "$ID"
    CHECK_RESULT $? 0 0 "check docker rm $ID failed"
    docker pod rm $(docker pod list -q)
    ID=$(docker create --privileged registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep '"Privileged": true'
    CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Privileged: true failed"
    ID=$(docker create --publish 23 registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep '23'
    CHECK_RESULT $? 0 0 "check docker inspect $ID | grep 23 failed"
    ID=$(docker create --publish-all registry.access.redhat.com/ubi8-minimal ls)
    docker inspect "$ID" | grep "PublishAllPorts"
    CHECK_RESULT $? 0 0 "check PublishAllPorts: false failed"
    docker create -q registry.access.redhat.com/ubi8-minimal ls
    CHECK_RESULT $? 0 0 "check docker create -q registry.access.redhat.com/ubi8-minimal ls failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    LOG_INFO "End to restore the test environment."
}

main "$@"
