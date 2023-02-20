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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL iSulad
    if [[ ${NODE1_FRAME} == "aarch64" ]]; then
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/aarch64/openEuler-docker.aarch64.tar.xz
        image_name="openEuler-docker.aarch64.tar.xz"
    else 
        wget https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/x86_64/openEuler-docker.x86_64.tar.xz
        image_name="openEuler-docker.x86_64.tar.xz"
    fi
    systemctl start isulad
    isula load -i $image_name
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    isula images | grep openeuler-20.03-lts-sp1
    CHECK_RESULT $? 0 0 "Check images failed."
    isula info
    CHECK_RESULT $? 0 0 "Check isula info failed."
    ls -l /var/lib/isulad | grep -E "isulad_tmpdir|engines|mnt|storage|volumes"
    CHECK_RESULT $? 0 0 "The isula directory lacks some things."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    isula stop -f $isula_id
    isula rm $(isula ps -a -q)
    isula rmi $(isula images -q)
    DNF_REMOVE
    rm -f $image_name
    LOG_INFO "End to restore the test environment."
}

main "$@"

