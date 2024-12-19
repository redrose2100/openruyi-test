#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the ubi8-minimals and conditions of the Mulan PSL v2.
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
# @Desc      :   docker-search
# ############################################
# shellcheck disable=SC1091

source ../common/common_podman.sh
function config_params() {
    LOG_INFO "Start loading data!"
    name="postgres"
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm -all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker search --limit 5 registry.access.redhat.com/ubi8-minimal | wc -l | grep 5
    CHECK_RESULT $?
    docker search --no-trunc ubi8-minimal | grep "ubi8-minimal"
    CHECK_RESULT $?
    docker search --authfile value ubi8-minimal | grep -i "DESCRIPTION"
    CHECK_RESULT $?
    docker search --format json ubi8-minimal | grep "json"
    CHECK_RESULT $?
    docker search --tls-verify=true ubi8-minimal | grep -i "NAME"
    CHECK_RESULT $?
    docker pull ubi8-minimal
    CHECK_RESULT $?
    id=$(docker run --name "${name}" -e POSTGRES_PASSWORD=secret -td ubi8-minimal)
    CHECK_RESULT $?
    docker ps -a | grep "${name}"
    CHECK_RESULT $?
    docker stats -a --no-stream
    CHECK_RESULT $?
    docker stats --no-stream "${id}" | grep "${name}"
    CHECK_RESULT $?
    docker stats --no-stream --format=json "${id}" | grep "${name}"
    CHECK_RESULT $?
    docker stats --no-stream --format "table {{.ID}} {{.Name}} {{.MemUsage}}" | grep "${name}"
    CHECK_RESULT $?
    docker stop "${id}"
    CHECK_RESULT $?
    docker rm "${id}"
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main "$@"
