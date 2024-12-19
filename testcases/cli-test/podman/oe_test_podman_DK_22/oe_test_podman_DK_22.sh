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
# @Date      :   2022.10.20
# @License   :   Mulan PSL v2
# @Desc      :   docker-search
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm --all
    cp ../common/test.json .
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker search --limit 5 ubi8-minimal | wc -l | grep 6
    CHECK_RESULT $? 0 0 'check docker search --limit 5 ubi8-minimal | wc -l | grep 6 failed'
    docker search --no-trunc ubi8-minimal | grep "ubi8-minimal"
    CHECK_RESULT $? 0 0 'check docker search --no-trunc ubi8-minimal | grep "ubi8-minimal" failed'
    docker search --authfile test.json ubi8-minimal | grep -i "DESCRIPTION"
    CHECK_RESULT $? 0 0 'check docker search --authfile test.json ubi8-minimal | grep -i "DESCRIPTION" failed'
    docker search --format json ubi8-minimal | grep "}"
    CHECK_RESULT $? 0 0 'check docker search --format json failed'
    docker search --tls-verify=true ubi8-minimal | grep -i "ubi8-minimal"
    CHECK_RESULT $? 0 0 'check docker search --tls-verify true failed'
    docker pull ubi8-minimal
    CHECK_RESULT $? 0 0 'check docker pull ubi8-minimal failed'
    id=$(docker create --name postgres -t ubi8-minimal | sed -n '$p')
    test -z "${id}"
    CHECK_RESULT $? 1 0 'check id failed'
    docker start postgres | grep postgres
    CHECK_RESULT $? 0 0 'check docker start postgres | grep postgres failed'
    docker ps -a | grep postgres | grep Up
    CHECK_RESULT $? 0 0 'check docker ps -a | grep postgres failed'
    docker stats -a --no-stream
    CHECK_RESULT $? 0 0 'check docker stats -a --no-stream failed'
    docker stats --no-stream "${id}" | grep postgres
    CHECK_RESULT $? 0 0 "check docker stats --no-stream ${id} | grep postgres failed"
    docker stats --no-stream --format=json "${id}" | grep postgres
    CHECK_RESULT $? 0 0 "check docker stats --no-stream --format=json ${id} | grep postgres failed"
    docker stats --no-stream --format "table {{.ID}} {{.Name}} {{.MemUsage}}" | grep postgres
    CHECK_RESULT $? 0 0 'check docker stats --no-stream --format failed'
    docker stop postgres
    CHECK_RESULT $? 0 0 'check odman stop postgres | grep postgres failed'
    docker ps -a | grep postgres | grep Exited
    docker rm "${id}"
    CHECK_RESULT $? 0 0 "check docker rm ${id} failed"
    docker search --limit 3 ubi8-minimal 2>&1 | grep "ubi8-minimal"
    CHECK_RESULT $? 0 0 'check docker search --limit 3 fedora 2>&1 | grep "dockerpull.org/library/fedora" failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.json
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main "$@"
