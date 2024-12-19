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
# @Contact   :   duanxuemin25812@163.com
# @Date      :   2022/10/11
# @License   :   Mulan PSL v2
# @Desc      :   The usage of commands in podman package
# ############################################
# shellcheck disable=SC1091

source "../common/common_podman.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    docker pull ubi8-minimal
    docker run --name postgres ubi8-minimal
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker stop postgres
    docker logs -f "$(docker ps -aq)"
    CHECK_RESULT $? 0 0 'check docker logs -f failed'
    docker logs -l
    CHECK_RESULT $? 0 0 'check docker logs -l failed'
    docker logs --since 2020-12-31 "$(docker ps -aq)"
    CHECK_RESULT $? 0 0 'check docker logs --since 2020-12-31 failed'
    docker logs --tail 10 "$(docker ps -aq)"
    CHECK_RESULT $? 0 0 'check docker logs --tail 10  failed'
    docker logs -t "$(docker ps -aq)"
    CHECK_RESULT $? 0 0 'check docker logs -t failed'
    docker start postgres
    docker save -q -o alpine.tar ubi8-minimal
    docker import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh --change LABEL=blue=image alpine.tar image-imported
    CHECK_RESULT $? 0 0 'check docker import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh failed'
    docker import -q --message "importing the alpine.tar tarball" alpine.tar image-imported
    CHECK_RESULT $? 0 0 'check cat alpine.tar | docker import -q --message failed'
    docker export -o redis-container.tar "$(docker ps -aq)"
    CHECK_RESULT $? 0 0 'check docker export -o redis-container.tar failed'
    test -f redis-container.tar
    CHECK_RESULT $? 0 0 'check test -f redis-container.tar failed'
    docker tag "$(docker images -q | tail -n 1)" test && docker images | grep test
    CHECK_RESULT $? 0 0 'check docker tag failed'
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
