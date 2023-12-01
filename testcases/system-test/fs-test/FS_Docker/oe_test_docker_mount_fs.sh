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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS))
    DNF_INSTALL docker
    if [[ ${NODE1_FRAME} == "aarch64" ]]; then
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
        image_name="openEuler-docker.aarch64.tar.xz"
    else
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/x86_64/openEuler-docker.x86_64.tar.xz
        image_name="openEuler-docker.x86_64.tar.xz"
    fi
    docker load -i $image_name
    image_id=$(docker images | grep openeuler-20.03-lts-sp1 | head -n 1 | awk '{print $3}')
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mount_dir=${point_list[$i]}
        docker create -it -v ${mount_dir}:/home/common $image_id /bin/bash
        docker_id=$(docker ps -a | grep "Created" | head -n 1 | awk '{print $1}')
        docker start $docker_id
        docker exec -t $docker_id /bin/bash -c 'df -iT | grep /home/common'
        CHECK_RESULT $? 0 0 "Mount on $i failed."
        docker exec -t $docker_id /bin/bash -c 'echo test > /home/common/testfile'
        CHECK_RESULT $? 0 0 "Write file in docker failed."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker kill $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
    DNF_REMOVE
    rm -rf /home/docker_dir $image_name
    LOG_INFO "End to restore the test environment."
}

main "$@"

