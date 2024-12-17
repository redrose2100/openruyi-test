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
# shellcheck disable=SC1091,2046

source "../common/common3.4.4.2_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ID=$(podman create --oom-kill-disable registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep '"OomKillDisable": true'
    CHECK_RESULT $? 0 0 "check OomKillDisable failed"
    ID=$(podman create --oom-score-adj 100 registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep '"OomKillDisable":'
    CHECK_RESULT $? 0 0 "check OomKillDisable failed"
    ID=$(podman create --pid host registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep '"PidMode": "host"'
    CHECK_RESULT $? 0 0 "check PidMode host failed"
    ID=$(podman create --pids-limit 3 registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep '"PidsLimit": 3'
    CHECK_RESULT $? 0 0 "check PidsLimit failed"
    podman pod create --infra=false
    ID=$(podman create --pod $(podman pod list -lq) registry.access.redhat.com/ubi8-minimal ls)
    podman rm "$ID"
    CHECK_RESULT $? 0 0 "check podman rm $ID failed"
    podman pod rm $(podman pod list -q)
    ID=$(podman create --privileged registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep '"Privileged": true'
    CHECK_RESULT $? 0 0 "check podman inspect $ID | grep Privileged: true failed"
    ID=$(podman create --publish 23 registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep '23'
    CHECK_RESULT $? 0 0 "check podman inspect $ID | grep 23 failed"
    ID=$(podman create --publish-all registry.access.redhat.com/ubi8-minimal ls)
    podman inspect "$ID" | grep "PublishAllPorts"
    CHECK_RESULT $? 0 0 "check PublishAllPorts: false failed"
    podman create -q registry.access.redhat.com/ubi8-minimal ls
    CHECK_RESULT $? 0 0 "check podman create -q registry.access.redhat.com/ubi8-minimal ls failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    find . -type f ! -name '*.sh' -exec rm -f {} +
    LOG_INFO "End to restore the test environment."
}

main "$@"
