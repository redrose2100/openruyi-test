#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Create bridge for docker
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL "docker bridge-utils net-tools"
    if [[ ${NODE1_FRAME} -eq "aarch64" ]]; then
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
        image_name="openEuler-docker.aarch64.tar.xz"
    else
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/x86_64/openEuler-docker.x86_64.tar.xz
        image_name="openEuler-docker.x86_64.tar.xz"
    fi

    docker load -i $image_name

    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    brctl show | grep -q "docker0"
    CHECK_RESULT $? 0 0 "Check docker0 brctl failed."
    docker network create docker_bridge
    CHECK_RESULT $? 0 0 "Create docker_bridge failed."
    network_id=$(docker network ls | grep "docker_bridge" | awk '{print $1}')
    brctl show | grep -q $network_id
    CHECK_RESULT $? 0 0 "Check docker_bridge failed."
    docker network rm docker_bridge
    docker network ls | grep -q "docker_bridge"
    CHECK_RESULT $? 1 0 "Check docker network list deleted failed."
    brctl show | grep -q $network_id
    CHECK_RESULT $? 1 0 "Check docker_bridge deleted failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    docker rmi $(docker images -q)
    rm -f $image_name
    ifconfig docker0 down
    brctl delbr docker0
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
