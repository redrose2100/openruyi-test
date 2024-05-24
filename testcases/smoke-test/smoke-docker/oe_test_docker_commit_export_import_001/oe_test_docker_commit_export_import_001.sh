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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Commit / export / import application of container
# ############################################

source "${OET_PATH}/testcases/smoke-test/smoke-docker/common/prepare_docker.sh"
function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_docker_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    run_docker_container
    docker commit "${containers_id}" "${Images_name}:test"
    CHECK_RESULT $?

    docker images | grep "${Images_name}" | grep -w test
    CHECK_RESULT $?

    EXPORT_IMAGE_NAME=export_test
    docker export "${containers_id}" > "${EXPORT_IMAGE_NAME}.tar"
    CHECK_RESULT $?
    test -f "${EXPORT_IMAGE_NAME}.tar"
    CHECK_RESULT $?

    clean_docker_env

    docker images | grep "${Images_name}"
    CHECK_RESULT $? 1
    docker import "${EXPORT_IMAGE_NAME}.tar" "${Images_name}:${TEST_TAG}"
    CHECK_RESULT $?
    docker images | grep "${Images_name}" | grep "${TEST_TAG}"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    docker rmi "$(docker images -q)"
    DNF_REMOVE "$@"
    rm -rf "${EXPORT_IMAGE_NAME}.tar"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
