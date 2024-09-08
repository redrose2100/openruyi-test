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
#@Desc      	:   Create bridge for docker
#####################################
# shellcheck disable=SC2154
# shellcheck source=/dev/null

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source ../common/docker.conf

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "wget docker bridge-utils net-tools"

    if [ -z "${docker_path}" ]; then
        LOG_INFO "Set version/url for docker in common/docker.conf first"
        exit 1
    fi

    image_file="openEuler-docker.${NODE1_FRAME}.tar.xz"
    docker_path="${docker_path}/${version}/docker_img/${NODE1_FRAME}/${image_file}"
    wget "${docker_path}"
    systemctl start docker
    SLEEP_WAIT 3

    docker load -i "${image_file}"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    brctl show | grep -q "docker0"
    CHECK_RESULT $? 0 0 "Check docker0 brctl failed."
    docker network create docker_bridge
    CHECK_RESULT $? 0 0 "Create docker_bridge failed."
    network_id=$(docker network ls | grep "docker_bridge" | awk '{print $1}')
    brctl show | grep -q "$network_id"
    CHECK_RESULT $? 0 0 "Check docker_bridge failed."
    docker network rm docker_bridge
    docker network ls | grep -q "docker_bridge"
    CHECK_RESULT $? 1 0 "Check docker network list deleted failed."
    brctl show | grep -q "$network_id"
    CHECK_RESULT $? 1 0 "Check docker_bridge deleted failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    image_ids=$(docker images -aq)
    for image_id in $image_ids; do
        docker rmi "$image_id" 
    done
    rm -rf "${image_file}"
    ifconfig docker0 down
    brctl delbr docker0
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
