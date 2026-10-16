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
#@Date      	:   2021-06-17
#@License   	:   Mulan PSL v2
#@Desc      	:   check isula info
#####################################
# shellcheck disable=SC1090,SC2010

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "lcr iSulad wget"

    systemctl start isulad
    echo "Architecture:${NODE1_FRAME}"
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

    isula load -i "$image_name"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    isula images | grep "${TEST_IMAGE}"
    CHECK_RESULT $? 0 0 "Check images failed."
    isula info
    CHECK_RESULT $? 0 0 "Check isula info failed."
    ls -l /var/lib/isulad | grep -E "isulad_tmpdir|engines|mnt|storage|volumes"
    CHECK_RESULT $? 0 0 "The isula directory lacks some things."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    containers_ids=$(isula ps -a -q)
    for container_id in ${containers_ids}; do
        isula stop -f "${container_id}"
        isula rm "${container_id}"
    done
    images_ids=$(isula images -q)
    for image_id in ${images_ids}; do
        isula rmi "${image_id}"
    done

    DNF_REMOVE "$@"
    rm -f "$image_name"
    LOG_INFO "End to restore the test environment."
}

main "$@"

