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
# @Desc      :   docker rm Test
# ############################################

source ../common/common_podman.sh
function config_params() {
    LOG_INFO "Start loading data!"
    name="postgres"
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    deploy_env
    docker rm --all
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    docker run --name ${name} registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $?
    docker ps -a | grep ${name}
    CHECK_RESULT $?
    docker stop ${name} | grep ${name}
    CHECK_RESULT $?
    docker rm ${name} 
    CHECK_RESULT $?
    docker run --name ${name}1 registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $?
    docker ps -a | grep ${name}1
    CHECK_RESULT $?
    docker stop ${name}1 | grep ${name}1
    CHECK_RESULT $?
    docker rm $(docker ps -a | sed -n 2p | awk -F " " '{print $1}')
    CHECK_RESULT $?
    docker run --name ${name}2 registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $?
    docker run --name ${name}3 registry.access.redhat.com/ubi8-minimal
    CHECK_RESULT $?
    docker stop ${name}2 ${name}3
    CHECK_RESULT $?
    docker rm ${name}2 ${name}3 
    CHECK_RESULT $?
    LOG_INFO "End executing testcase."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clear_env
    LOG_INFO "Finish environment cleanup."
}

main $@
