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
#@Date      	:   2021-06-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Mount file in isula
#####################################
# shellcheck disable=SC1090,SC2010

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "iSulad syscontainer-tools lxcfs-tools lxcfs tar lcr"
    sed -i '/runc/s/runc/lcr/' /etc/isulad/daemon.json
    if [[ ${NODE1_FRAME} == "aarch64" ]]; then
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
        image_name="openEuler-docker.aarch64.tar.xz"
    else
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/x86_64/openEuler-docker.x86_64.tar.xz
        image_name="openEuler-docker.x86_64.tar.xz"
    fi
    systemctl start lxcfs
    systemctl restart isulad
    mkdir /opt/rootfs
    cp "$image_name" /opt/rootfs
    xz -d /opt/rootfs/"$image_name"
    img_tar=$(find /opt/rootfs -name "*.tar" | awk -F"/" '{print $NF}')
    tar -xf /opt/rootfs/"$img_tar" --directory /opt/rootfs
    root_tar=$(ls /opt/rootfs/*tar* | grep -v "$img_tar" | awk -F"/" '{print $NF}')
    tar -xf /opt/rootfs/"$root_tar" --directory /opt/rootfs
    isula load -i "$image_name"
    image_id=$(isula images | grep openeuler-20.03-lts-sp1 | head -n 1 | awk '{print $3}')
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    isula run -itd -n systest --system-container --external-rootfs /opt/rootfs "$image_id"
    CHECK_RESULT $? 0 0 "Create system isula failed."
    isula ps -a | grep systest | grep "Up"
    CHECK_RESULT $? 0 0 "Check system isula failed."
    isula exec systest ls
    CHECK_RESULT $? 0 0 "Execute system isula failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    isula stop -f systest
    isula rm "$(isula ps -a -q)"
    isula rmi "$(isula images -q)"
    systemctl stop lxcfs
    systemctl stop isulad
    DNF_REMOVE "$@"
    rm -rf /opt/rootfs "$image_name"
    LOG_INFO "End to restore the test environment."
}

main "$@"

