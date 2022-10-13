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
# @Desc      :   docker container exec top
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
    id=$(docker create --name postgres docker.io/library/nginx | sed -n '$p')
    CHECK_RESULT $?
    docker container stop postgres
    CHECK_RESULT $?
    docker container rm postgres | grep ${id}
    CHECK_RESULT $?
    docker container ls | grep postgres
    CHECK_RESULT $? 1
    id1=$(docker create --name postgres1 docker.io/library/nginx | sed -n '$p')
    CHECK_RESULT $?
    docker container stop postgres1
    CHECK_RESULT $?
    docker container cleanup postgres1
    CHECK_RESULT $?
    docker create --name postgres2 docker.io/library/nginx | sed -n '$p'
    CHECK_RESULT $?
    docker start postgres2
    docker exec -it postgres2 ls | grep "bin"
    CHECK_RESULT $?
    docker exec --privileged postgres2 ls | grep "docker-entrypoint.d"
    CHECK_RESULT $?
    docker exec --user root postgres2 ls | grep "home"
    docker stop postgres2
    CHECK_RESULT $?
    docker rm postgres2 postgres1
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
