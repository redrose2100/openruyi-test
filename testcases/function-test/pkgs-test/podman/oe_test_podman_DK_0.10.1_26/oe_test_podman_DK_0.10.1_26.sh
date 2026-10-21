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
# @Desc      :   docker build
# ############################################
# shellcheck disable=SC1091,SC2119

source ../common/common_podman.sh
source "../common/versioncheck.sh"


function pre_test() {
    version_check
    LOG_INFO "Start environment preparation."
    deploy_env
    DNF_INSTALL "cpp"
    docker rm -all
    echo "FROM ubi8-minimal:latest
RUN ls" >Dockerfile
    cp -f Dockerfile Dockerfile.simple
    cp -f Dockerfile Dockerfile.in
    cp -f Dockerfile Containerfile.notsosimple
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    version_check
    LOG_INFO "Start executing testcase."
    docker build . >>test.log
    CHECK_RESULT $?
    id=$(awk '{print $2}' test.log)
    docker build -f ./Dockerfile . | grep "${id}"
    CHECK_RESULT $?
    docker build --runtime-flag debug . | grep "${id}"
    CHECK_RESULT $?
    docker build --authfile /tmp/auths/myauths.json --cert-dir "$HOME"/auth --tls-verify=true --creds=username:password -t hjfd -f ./Dockerfile.simple . | grep "${id}"
    CHECK_RESULT $?
    docker build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit nofile=1024:1028 -t imagenam . | grep "${id}"
    CHECK_RESULT $?
    docker build -f Dockerfile.simple -f Containerfile.notsosimple . | grep "${id}"
    CHECK_RESULT $?
    docker build -f Dockerfile.in "${HOME}" | grep "${id}"
    CHECK_RESULT $?
    docker build --no-cache --rm=false -t newimages1 .
    CHECK_RESULT $?
    docker build --layers --force-rm -t testname .
    CHECK_RESULT $?
    docker build --no-cache -t imageert .
    CHECK_RESULT $?
    docker rmi -force --all
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf Docker* Containerfile* common* test.log
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main "$@"
