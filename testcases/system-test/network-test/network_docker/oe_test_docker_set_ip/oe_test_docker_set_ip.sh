#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Set ip for docker
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL docker
    frame="aarch64"
    if [[ ${NODE1_FRAME} -eq ${frame} ]]; then
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
        image_name="openEuler-docker.aarch64.tar.xz"
    else
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/x86_64/openEuler-docker.x86_64.tar.xz
        image_name="openEuler-docker.x86_64.tar.xz"
    fi
    docker load -i $image_name
    docker network create docker_bridge
    new_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1).0.0.8
    subnet=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1).0.0.0
    docker network create --subnet="${subnet}"/16 testnet
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker run -itd --net testnet --ip "${new_ip}" --name "test_docker" "openeuler-20.03-lts-sp1"
    CHECK_RESULT $? 0 0 "Check docker created failed."
    docker ps -a | grep "test_docker"
    CHECK_RESULT $? 0 0 "Check test_docker created failed."
    docker_id=$(docker ps -a | grep "test_docker" | head -n 1 | awk '{print $1}')
    docker inspect "$docker_id" | grep "\"IPv4Address\": \"$new_ip\""
    CHECK_RESULT $? 0 0 "Check ip in docker failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker rm -f "$docker_id"
    docker network rm testnet
    docker rmi "$(docker images -q)"
    rm -f $image_name
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
