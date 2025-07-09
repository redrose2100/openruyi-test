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
# shellcheck disable=SC1091,SC2119

source "../common/common_podman.sh"
source "../common/versioncheck.sh"


function pre_test() {
    version_check
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    podman pull ubi8-minimal
    podman run --name postgres -e POSTGRES_PASSWORD=secret -td ubi8-minimal ls -l
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    version_check
    LOG_INFO "Start to run test."
    docker stop postgres
    docker logs -f "$(docker ps -aq)" | grep "total"
    CHECK_RESULT $?
    docker logs -l | grep "root"
    CHECK_RESULT $?
    docker logs --since 2020-12-31 "$(docker ps -aq)" 2>&1 | grep "[0-9]"
    CHECK_RESULT $?
    docker logs --tail 10 "$(podman ps -aq)" 2>&1 | grep -cv "Docker CLI using podman" | grep 10
    CHECK_RESULT $?
    docker logs -t "$(docker ps -aq)" | grep "+08:00"
    CHECK_RESULT $?
    docker start postgres
    docker save -q -o alpine.tar ubi8-minimal
    docker import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh --change LABEL=blue=image alpine.tar image-imported
    CHECK_RESULT $?
    docker import -q --message "importing the alpine.tar tarball" alpine.tar image-imported
    CHECK_RESULT $?
    docker export -o redis-container.tar "$(docker ps -aq)"
    CHECK_RESULT $?
    test -f redis-container.tar
    CHECK_RESULT $?
    docker tag "$(docker images -q | tail -n 1)" test && docker images | grep test
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker rmi test
    clear_env
    rm -rf redis-container.tar alpine.tar
    LOG_INFO "End to restore the test environment."
}

main "$@"
