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
#@Desc      	:   Check docker network format
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
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker network list | grep -Eq "host|bridge|none"
    CHECK_RESULT $? 0 0 "Check default network format failed."
    docker run -itd --net host --name test_docker1 "openeuler-20.03-lts-sp1"
    CHECK_RESULT $? 0 0 "Create docker with set net=host failed."
    docker run -itd --net bridge --name test_docker2 "openeuler-20.03-lts-sp1"
    CHECK_RESULT $? 0 0 "Create docker with set net=bridge failed."
    docker run -itd --net none --name test_docker3 "openeuler-20.03-lts-sp1"
    CHECK_RESULT $? 0 0 "Create docker with set net=none failed."
    docker_id1=$(docker ps -a | grep "test_docker1" | head -n 1 | awk '{print $1}')
    docker_id2=$(docker ps -a | grep "test_docker2" | head -n 1 | awk '{print $1}')
    docker_id3=$(docker ps -a | grep "test_docker3" | head -n 1 | awk '{print $1}')
    docker inspect "$docker_id1" | grep "\"NetworkMode\": \"host\""
    CHECK_RESULT $? 0 0 "check test_docker1 with set net=host failed."
    docker inspect "$docker_id2" | grep "\"NetworkMode\": \"bridge\""
    CHECK_RESULT $? 0 0 "check test_docker2 with set net=bridge failed."
    docker inspect "$docker_id3" | grep "\"NetworkMode\": \"none\""
    CHECK_RESULT $? 0 0 "check test_docker3 with set net=none failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker rm -f "$docker_id1" "$docker_id2" "$docker_id3"
    docker network rm docker_bridge
    docker rmi "$(docker images -q)"
    rm -f $image_name
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
