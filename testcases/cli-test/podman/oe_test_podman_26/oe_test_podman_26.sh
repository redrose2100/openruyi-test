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
# @Date      :   2022.10.11
# @License   :   Mulan PSL v2
# @Desc      :   podman build
# ############################################
# shellcheck disable=SC1091

source "../common/common3.4.4.2_podman.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL cpp
    deploy_env
    podman rm --all
    podman rmi --all
    echo '"auths": {}' >myauths.json
    echo "FROM alpine:latest
RUN apk add nano" >Dockerfile
    cp -f Dockerfile Dockerfile.simple
    cp -f Dockerfile Dockerfile.in
    cp -f Dockerfile Containerfile.notsosimple
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    id=$(podman build . | sed -n '$p')
    test -z "${id}"
    CHECK_RESULT $? 1 0 'check id failed'
    podman build -f - . <./Dockerfile | grep "${id}"
    CHECK_RESULT $? 0 0 "check cat ./Dockerfile | podman build -f - . | grep ${id} failed"
    podman build --runtime-flag debug . | grep "${id}"
    CHECK_RESULT $? 0 0 "check podman build --runtime-flag debug . | grep ${id} failed"
    podman build --authfile myauths.json --cert-dir "$HOME"/auth --tls-verify=true --creds=username:password -t hjfd -f ./Dockerfile.simple . | grep "${id}"
    CHECK_RESULT $? 0 0 'check podman build --authfile ./authdir/myauths.json --cert-dir failed'
    podman build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit nofile=1024:1028 -t imagenam . | grep "${id}"
    CHECK_RESULT $? 0 0 'check podman build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit failed'
    podman build -f Dockerfile.simple -f Containerfile.notsosimple . | grep "${id}"
    CHECK_RESULT $? 0 0 'check podman build -f Dockerfile.simple -f Containerfile.notsosimple . failed'
    podman build -f Dockerfile.in "${HOME}" | grep "${id}"
    CHECK_RESULT $? 0 0 "check podman build -f Dockerfile.in ${HOME} | grep ${id} failed"
    podman build --no-cache --rm=false -t newimages1 . | grep "Successfully tagged localhost/newimages1:latest"
    CHECK_RESULT $? 0 0 'check podman build --no-cache --rm=false -t newimages1 . failed'
    podman build --layers --force-rm -t testname . | grep "${id}"
    CHECK_RESULT $? 0 0 'check podman build --layers --force-rm -t testname . failed'
    podman build --no-cache -t imageert . | grep "Successfully tagged localhost/imageert:latest"
    CHECK_RESULT $? 0 0 'check podman build --no-cache -t imageert . failed'
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    find . -type f ! -name '*.sh' -exec rm -f {} +
    rm -f common*
    clear_env
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main "$@"
