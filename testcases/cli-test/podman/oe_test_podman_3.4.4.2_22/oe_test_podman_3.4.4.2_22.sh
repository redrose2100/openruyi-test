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
# @Desc      :   podman-search
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    cp ../common/test.json .
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    podman search --limit 5 term | wc -l | grep 6
    CHECK_RESULT $?
    podman search --no-trunc term | grep "docker.io"
    CHECK_RESULT $?
    podman search --authfile test.json term | grep -i "DESCRIPTION"
    CHECK_RESULT $?
    podman search json --format json | grep "json"
    CHECK_RESULT $?
    podman search --tls-verify true
    podman search --tls-verify true | grep -i "docker.io"
    CHECK_RESULT $?
    podman pull docker.io/library/nginx
    CHECK_RESULT $?
    id=$(podman create --name postgres docker.io/library/nginx | sed -n '$p')
    CHECK_RESULT $?
    podman start postgres | grep postgres
    CHECK_RESULT $?
    podman ps -a | grep postgres
    CHECK_RESULT $?
    podman stats -a --no-stream
    CHECK_RESULT $?
    podman stats --no-stream ${id} | grep postgres
    CHECK_RESULT $?
    podman stats --no-stream --format=json ${id} | grep postgres
    CHECK_RESULT $?
    podman stats --no-stream --format "table {{.ID}} {{.Name}} {{.MemUsage}}" | grep postgres
    CHECK_RESULT $?
    podman stop postgres | grep postgres
    CHECK_RESULT $?
    podman rm ${id}
    CHECK_RESULT $?
    podman search --limit 3 fedora 2>&1 | grep "docker.io/library/fedora"
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf test.json
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
