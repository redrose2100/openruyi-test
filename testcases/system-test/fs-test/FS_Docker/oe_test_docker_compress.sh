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
#@Date      	:   2021-06-10
#@License   	:   Mulan PSL v2
#@Desc      	:   Compress and run docker
#####################################
# shellcheck disable=SC1090,SC2034

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    EXECUTE_T="60m"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "docker gcc"
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        TEST_TAG=24.03
        TEST_IMAGE=jchzhou/oerv
        image_name="${TEST_TAG}_docker_image.tar.gz"
        wget "https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/2403LTS-test/v1/${image_name}"
    else
        TEST_IMAGE=openeuler-20.03-lts-sp1
        wget "https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/${NODE1_FRAME}/openEuler-docker.${NODE1_FRAME}.tar.xz"
        image_name="openEuler-docker.${NODE1_FRAME}.tar.xz"
    fi
    cur_path="$(pwd)"
    cd ../common_lib/fault_injection/inject_mem_overloading_malloc || exit
    bash inject_mem_overloading_malloc.sh inject
    cd "$cur_path" || exit
    systemctl start docker
    SLEEP_WAIT 3
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker load -i "$image_name"
    image_id=$(docker images | grep ${TEST_IMAGE} | head -n 1 | awk '{print $3}')
    mkdir -p /home/docker_dir
    docker create -it -v /home/docker_dir:/home/common "$image_id" /bin/bash 
    docker_id=$(docker ps -a | grep "Created" | head -n 1 | awk '{print $1}')
    docker start "$docker_id"
    CHECK_RESULT $? 0 0 "Start docker failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd ../common_lib/fault_injection/inject_mem_overloading_malloc || exit
    bash inject_mem_overloading_malloc.sh clean
    cd "$cur_path" || exit
    docker rm -f "$docker_id"
    docker rmi "$(docker images -q)"
    DNF_REMOVE "$@"
    rm -rf /home/docker_dir "$image_name"
    LOG_INFO "End to restore the test environment."
}

main "$@"
