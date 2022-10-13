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

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm --all
    docker rmi --all
    cp ../common/* .
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    id=$(docker build . | sed -n '$p')
    CHECK_RESULT $?
    cat ./Dockerfile | docker build -f - . | grep ${id}
    CHECK_RESULT $?
    docker build --runtime-flag debug . | grep ${id}
    CHECK_RESULT $?
    docker build --authfile ./authdir/myauths.json --cert-dir $HOME/auth --tls-verify=true --creds=username:password -t hjfd -f ./Dockerfile.simple . | grep ${id}
    CHECK_RESULT $?
    docker build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit nofile=1024:1028 -t imagenam . | grep ${id}
    CHECK_RESULT $?
    docker build -f Dockerfile.simple -f Containerfile.notsosimple . | grep ${id}
    CHECK_RESULT $?
    docker build -f Dockerfile.in ${HOME} | grep ${id}
    CHECK_RESULT $?
    docker build --no-cache --rm=false -t newimages1 . | grep "Successfully tagged localhost/newimages1:latest"
    CHECK_RESULT $?
    docker build --layers --force-rm -t testname . | grep ${id}
    CHECK_RESULT $?
    docker build --no-cache -t imageert . | grep "Successfully tagged localhost/imageert:latest"
    CHECK_RESULT $?
    docker rmi --all
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf Docker* Containerfile* common* test.json
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
