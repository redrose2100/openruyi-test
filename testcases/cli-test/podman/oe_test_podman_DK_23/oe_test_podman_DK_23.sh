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
# @Contact   :   duanxuemin@foxmail.com
# @Date      :   2022.10.11
# @License   :   Mulan PSL v2
# @Desc      :   docker-mount-unmount
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker pull alpine
    CHECK_RESULT $? 0 0 'check docker pull alpine failed'
    id=$(docker create --name postgres -t alpine)
    test -z "${id}"
    CHECK_RESULT $? 1 0 "check id=$(docker create --name postgres -t alpine) failed"
    docker start postgres
    CHECK_RESULT $? 0 0 'check docker start postgres failed'
    docker top -l | grep "USER"
    CHECK_RESULT $? 0 0 'check docker top -l | grep "USER" failed'
    docker top postgres | grep "USER"
    CHECK_RESULT $? 0 0 'check docker top postgres | grep "USER" failed'
    docker mount --format json | grep "id"
    CHECK_RESULT $? 0 0 'check docker mount --format json | grep "id" failed'
    docker mount --notruncate | grep merged
    CHECK_RESULT $? 0 0 'check docker mount --notruncate | grep merged failed'
    docker stop postgres
    CHECK_RESULT $? 0 0 'check docker stop postgres failed'
    docker unmount -f postgres | grep postgres
    CHECK_RESULT $? 0 0 'check docker unmount -f postgres | grep postgres failed'
    docker mount postgres
    CHECK_RESULT $? 0 0 'check docker mount postgres failed'
    docker unmount --all
    CHECK_RESULT $? 0 0 'check docker unmount --all failed'
    docker rm postgres | grep -E "${id}|postgres"
    CHECK_RESULT $? 0 0 "check docker rm postgres | grep ${id} failed"
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main "$@"
