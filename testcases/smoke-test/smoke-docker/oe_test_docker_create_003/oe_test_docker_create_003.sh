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
# @Desc      :   Background run container (run in background after creation)
# ############################################


source "${OET_PATH}/testcases/smoke-test/smoke-docker/common/prepare_docker.sh"
function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_docker_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    containers_id=$(docker run -d "${Images_name}:${TEST_TAG}" /bin/sh -c "while true;do echo hello world;sleep 1;done")
    CHECK_RESULT $?

    docker inspect -f "{{.State.Status}}" "${containers_id}" | grep running
    CHECK_RESULT $?

    docker logs "${containers_id}" | grep "hello world"
    CHECK_RESULT $?

    WAIT_CHECK_TIME=5
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        # jchzhou/24.03 has problem when curl, may be use riscv64/ubuntu as a tmp image
        Images_name=riscv64/ubuntu
        TEST_TAG=latest
        EXTRA_RUN_CMD="apt update && apt install curl -y && "
        WAIT_CHECK_TIME=600
    fi
    containers_id=$(docker run -d "${Images_name}:${TEST_TAG}" /bin/sh -c "${EXTRA_RUN_CMD} curl www.baidu.com")
    CHECK_RESULT $?
    SLEEP_WAIT "${WAIT_CHECK_TIME}"
    docker logs "${containers_id}" 2>&1 | grep "!--STATUS OK--"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_docker_env
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
