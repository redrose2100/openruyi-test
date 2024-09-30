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
#@Desc      	:   Set ip for docker
#####################################
# shellcheck disable=SC2154
# shellcheck source=/dev/null

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source ../common/docker.conf

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "wget docker net-tools bridge-utils"

    if [ -z "${docker_path}" ]; then
        LOG_INFO "Set version/url for docker in common/docker.conf first"
        exit 1
    fi

    DEFAULT_RUN_CMD="/bin/bash"
    image_name=$(echo "${version}" | awk '{print tolower($0)}')
    image_file="openEuler-docker.${NODE1_FRAME}.tar.xz"
    docker_path="${docker_path}/${version}/docker_img/${NODE1_FRAME}/${image_file}"
    wget "${docker_path}"
    systemctl start docker
    SLEEP_WAIT 3

    docker load -i "${image_file}"
    # get image tag by image name
    image_tag=$(docker images -a | grep "${image_name}" | awk '{print $2}')

    docker network create docker_bridge
    new_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1).0.0.8
    subnet=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1).0.0.0
    docker network create --subnet="${subnet}"/16 testnet
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker run -itd --net testnet --ip "${new_ip}" --name "test_docker" "${image_name}:${image_tag}" "${DEFAULT_RUN_CMD}"
    CHECK_RESULT $? 0 0 "Check docker created failed."
    docker ps -a | grep "test_docker"
    CHECK_RESULT $? 0 0 "Check test_docker created failed."
    docker_id=$(docker ps -a | grep "test_docker" | head -n 1 | awk '{print $1}')
    docker inspect "$docker_id" | grep "\"IPv4Address\": \"$new_ip\""
    CHECK_RESULT $? 0 0 "Check ip in docker failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker rm -f "$docker_id"
    docker network rm testnet
    docker network rm docker_bridge
    image_ids=$(docker images -aq)
    for image_id in $image_ids; do
        docker rmi "$image_id" 
    done
    rm -rf "$image_file"
    ifconfig docker0 down
    brctl delbr docker0
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
