#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-07
#@License   	:   Mulan PSL v2
#@Desc      	:   write file on docker 
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL docker
    
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
        TEST_TAG=24.03
        TEST_IMAGE=jchzhou/oerv
        image_name="${TEST_TAG}_docker_image.tar.gz"
        wget "https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/2403LTS-test/v1/${image_name}"
    else
        TEST_IMAGE=openeuler-20.03-lts-sp1
        wget "https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/${NODE1_FRAME}/openEuler-docker.${NODE1_FRAME}.tar.xz"
        image_name="openEuler-docker.${NODE1_FRAME}.tar.xz"
    fi

    docker load -i "$image_name"
    image_id=$(docker images | grep ${TEST_IMAGE} | head -n 1 | awk '{print $3}')
    mkdir -p /home/docker_dir
    docker create -it -v /home/docker_dir:/home/common "$image_id" /bin/bash 
    docker_id=$(docker ps -a | grep "Created" | head -n 1 | awk '{print $1}')
    upper_dir=$(docker inspect "$docker_id" | grep UpperDir | awk '{print $2}' | cut -d '"' -f 2)
    docker start "$docker_id"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker exec -t "$docker_id" /bin/bash -c 'echo testfile > /testfile'
    CHECK_RESULT $? 0 0 "Write file in docker failed."
    grep testfile  "$upper_dir/testfile"
    CHECK_RESULT $? 0 0 "Check file in upper_dir failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker rm -f "$docker_id"
    docker rmi "$(docker images -q)"
    DNF_REMOVE "$@"
    rm -rf /home/docker_dir "$image_name"
    LOG_INFO "End to restore the test environment."
}

main "$@"

