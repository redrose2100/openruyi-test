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
#@Desc      	:   mount share dir on different fs type(ext3/ext4/xfs)
#####################################
# shellcheck disable=SC1091

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list="($(CREATE_FS))"
    DNF_INSTALL "docker wget"
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
    systemctl start docker
    SLEEP_WAIT 3
    docker load -i "$image_name"
    image_id=$(docker images | grep ${TEST_IMAGE} | head -n 1 | awk '{print $3}')
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mount_dir=${point_list[$i]}
        docker create -it -v "${mount_dir}:/home/common" "$image_id" /bin/bash
        docker_id=$(docker ps -a | grep "Created" | head -n 1 | awk '{print $1}')
        docker start "$docker_id"
        docker exec -t "$docker_id" /bin/bash -c 'df -iT | grep /home/common'
        CHECK_RESULT $? 0 0 "Mount on $i failed."
        docker exec -t "$docker_id" /bin/bash -c 'echo test > /home/common/testfile'
        CHECK_RESULT $? 0 0 "Write file in docker failed."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker kill "$(docker ps -a -q)"
    docker rm "$(docker ps -a -q)"
    docker rmi "$(docker images -q)"
    DNF_REMOVE "$@"
    rm -rf /home/docker_dir "$image_name"
    LOG_INFO "End to restore the test environment."
}

main "$@"

