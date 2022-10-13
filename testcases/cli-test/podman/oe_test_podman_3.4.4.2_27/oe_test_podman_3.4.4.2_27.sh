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
# @Desc      :   podman build
# ############################################

source ../common/common_podman.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    podman rm --all
    cp ../common/* .
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    value=$(podman build --security-opt label=level:s0:c100,c200 --cgroup-parent /path/to/cgroup/parent -t imageme . | sed -n '$p')
    CHECK_RESULT $?
    podman build --authfile temp-auths/myauths.json --cert-dir $HOME/auth --tls-verify=true --creds=username:password -t imageme -f Dockerfile.simple . | grep ${value}
    CHECK_RESULT $?
    podman build --runtime-flag log-format=json . | grep ${value}
    CHECK_RESULT $?
    podman build --tls-verify=false -t imagename . | grep ${value}
    CHECK_RESULT $?
    podman build --tls-verify=true -t imagename1 -f Dockerfile.simple . | grep ${value}
    CHECK_RESULT $?
    podman build -t imag . | grep ${value}
    CHECK_RESULT $?
    podman rmi --all
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf Dockerfile* common* Containerfile*
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
