#!/usr/bin/bash

# Copyright (c) 2022.Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   prepare docker
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_docker_env() {
    # avoid conflict between docker and containerd
    rm -rf /run/containerd
    DNF_INSTALL "docker wget tar"

    if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "("; then
        os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | tr '()' '- ' | sed s/[[:space:]]//g)
    else
        if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "LTS"; then
            os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | awk -F ' ' '{print$1"-"$2}')
        else
            os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}')
        fi
    fi

    DEFAULT_RUN_CMD="/bin/bash"
    IMAGE_LOCAL_PATH="../common"
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        TEST_TAG=24.03
        TEST_IMAGE=jchzhou/oerv
        image_name=${TEST_TAG}_docker_image.tar.gz
        image_path="https://repo.tarsier-infra.isrc.ac.cn/openEuler-RISC-V/testing/2403LTS-test/v1/${image_name}"
    else
        TEST_TAG=latest
        TEST_IMAGE=openeuler-${os_version}
        image_name="openEuler-docker.${NODE1_FRAME}.tar.xz"
        image_path="https://repo.openeuler.org/openEuler-${os_version}/docker_img/${NODE1_FRAME}/${image_name}"
    fi
    clean_docker_env

    wget -P "${IMAGE_LOCAL_PATH}" "${image_path}"
    docker load -i "${IMAGE_LOCAL_PATH:?}/${image_name}"
    Images_name=$(docker images | grep -i "${TEST_IMAGE}" | awk '{print$1}')
    test -n "${Images_name}" || exit 1
}

function run_docker_container() {
    containers_id=$(docker run -itd "${Images_name}:${TEST_TAG}" "${DEFAULT_RUN_CMD}")
    CHECK_RESULT $?
    docker inspect -f "{{.State.Status}}" "${containers_id}" | grep running
    CHECK_RESULT $?
}

function clean_docker_env() {
    containers_ids=$(docker ps -aq)
    for container_id in ${containers_ids}; do
        docker stop "${container_id}"
        docker rm "${container_id}"
    done
    images_ids=$(docker images -aq)
    for image_id in ${images_ids}; do
        docker rmi "${image_id}"
        test -z "${image_id}"
    done
    rm -rf "${IMAGE_LOCAL_PATH:?}/${image_name}"
    CHECK_RESULT $?
    # avoid conflict between docker and containerd
    rm -rf /run/containerd

}
