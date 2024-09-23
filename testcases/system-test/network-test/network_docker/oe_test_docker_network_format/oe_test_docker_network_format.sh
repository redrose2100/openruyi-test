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
#@Desc      	:   Check docker network format
#####################################
# shellcheck disable=SC2154
# shellcheck source=/dev/null

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source ../common/docker.conf

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "wget docker net-tools bridge-utils"
    
    DEFAULT_RUN_CMD="/bin/bash"
    if [[ ${NODE1_FRAME} == "riscv64" ]]; then
        docker_path="${docker_path}/${image_file}"
    else
        image_name=$(echo "${version}" | awk '{print tolower($0)}')
        image_file="openEuler-docker.${NODE1_FRAME}.tar.xz"
        docker_path="${docker_path}/${NODE1_FRAME}/${image_file}"
    fi
    wget "${docker_path}"
    systemctl start docker
    SLEEP_WAIT 3
    docker load -i "${image_file}"
    image_tag=$(docker images -a | grep "${image_name}" | awk '{print $2}')

    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    docker network list | grep -Eq "host|bridge|none"
    CHECK_RESULT $? 0 0 "Check default network format failed."
    docker run -itd --net host --name test_docker1 "${image_name}:${image_tag}"  "${DEFAULT_RUN_CMD}"
    CHECK_RESULT $? 0 0 "Create docker with set net=host failed."
    docker run -itd --net bridge --name test_docker2 "${image_name}:${image_tag}"  "${DEFAULT_RUN_CMD}"
    CHECK_RESULT $? 0 0 "Create docker with set net=bridge failed."
    docker run -itd --net none --name test_docker3 "${image_name}:${image_tag}"  "${DEFAULT_RUN_CMD}"
    CHECK_RESULT $? 0 0 "Create docker with set net=none failed."
    docker_id1=$(docker ps -a | grep "test_docker1" | head -n 1 | awk '{print $1}')
    docker_id2=$(docker ps -a | grep "test_docker2" | head -n 1 | awk '{print $1}')
    docker_id3=$(docker ps -a | grep "test_docker3" | head -n 1 | awk '{print $1}')
    docker inspect "$docker_id1" | grep "\"NetworkMode\": \"host\""
    CHECK_RESULT $? 0 0 "check test_docker1 with set net=host failed."
    docker inspect "$docker_id2" | grep "\"NetworkMode\": \"bridge\""
    CHECK_RESULT $? 0 0 "check test_docker2 with set net=bridge failed."
    docker inspect "$docker_id3" | grep "\"NetworkMode\": \"none\""
    CHECK_RESULT $? 0 0 "check test_docker3 with set net=none failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    docker rm -f "$docker_id1" "$docker_id2" "$docker_id3"
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
