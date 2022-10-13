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
# @Date      :   2020.4.27
# @License   :   Mulan PSL v2
# @Desc      :   docker-start-pause-unpause
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm --all
    docker rmi --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker create --name postgres docker.io/library/nginx
    CHECK_RESULT $?
    docker create --name postgres1 docker.io/library/nginx
    CHECK_RESULT $?
    docker create --name postgres2 docker.io/library/nginx
    CHECK_RESULT $?
    docker ps -a | grep postgres
    CHECK_RESULT $?
    docker ps -all | grep -E "postgres|postgres1|postgre2"
    CHECK_RESULT $?
    docker start postgres postgres2
    CHECK_RESULT $?
    docker start $(docker ps -a | sed -n 2p | awk -F " " {'print $1'})
    CHECK_RESULT $?
    docker start -i -l
    CHECK_RESULT $?
    docker pause postgres1 postgres2 | grep -i "$(docker ps -a | awk -F " " {'print $1'})"
    CHECK_RESULT $?
    docker ps -a | grep postgres1
    CHECK_RESULT $?
    docker unpause postgres1 postgres2 | grep -i "$(docker ps -a | awk -F " " {'print $1'})"
    CHECK_RESULT $?
    docker stop postgres postgres1 postgres2
    CHECK_RESULT $?
    docker rm postgres postgres1 postgres2
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
