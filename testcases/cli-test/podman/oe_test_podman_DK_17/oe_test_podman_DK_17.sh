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
    docker pull alpine
    docker run --name postgres alpine
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker image history --format=json alpine | grep "created"
    CHECK_RESULT $? 0 0 'check docker image history --format=json alpine | grep "created" failed'
    docker image history --human alpine | grep "B"
    CHECK_RESULT $? 0 0 'check docker image history --human alpine | grep "B" failed'
    docker image history --no-trunc alpine | grep "$(docker images -aq)"
    CHECK_RESULT $? 0 0 'check docker image history --no-trunc alpine failed'
    docker image history -q alpine | grep "$(docker images -aq)"
    CHECK_RESULT $? 0 0 'check docker image history -q alpine  failed'
    docker image ls --filter after=alpine
    CHECK_RESULT $? 0 0 'check docker image ls --filter after=alpine failed'
    docker image ls --all | grep "alpine"
    CHECK_RESULT $? 0 0 'check docker image ls --all | grep "alpine" failed'
    docker image ls --digests | grep "DIGEST"
    CHECK_RESULT $? 0 0 'check docker image ls --digests | grep "DIGEST" failed'
    docker image ls --format json | grep "alpine"
    CHECK_RESULT $? 0 0 'check docker image ls --format json | grep "alpine" failed'
    docker image ls --no-trunc | grep "sha256"
    CHECK_RESULT $? 0 0 'check docker image ls --no-trunc | grep "sha256" failed'
    docker image ls --noheading | grep "TAG"
    CHECK_RESULT $? 1 0 'check docker image ls --noheading | grep "TAG" failed'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    clear_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
