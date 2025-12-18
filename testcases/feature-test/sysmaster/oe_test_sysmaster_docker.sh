#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/08/14
# @License   :   Mulan PSL v2
# @Desc      :   sysmaster docker 环境测试
# ############################################
# shellcheck disable=SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    DNF_INSTALL "docker wget"
    wget "https://repo.openeuler.org/openEuler-24.03-LTS-SP2/docker_img/${NODE1_FRAME}/openEuler-docker.${NODE1_FRAME}.tar.xz"
    xz -d "openEuler-docker.${NODE1_FRAME}.tar.xz"
    docker load --input "openEuler-docker.${NODE1_FRAME}.tar"
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    docker build -t openeuler-sysmaster:latest .
    CHECK_RESULT $? 0 0 "Build docker image failed"
    
    docker run -itd --privileged --name sysmaster-container openeuler-sysmaster:latest
    CHECK_RESULT $? 0 0 "Run container failed"
    
    sysmaster_docker_id=$(docker ps -a | grep openeuler-sysmaster | head -n 1 | awk '{print $1}')
    if grep cloudroot /etc/passwd;then
        docker exec "${sysmaster_docker_id}" sctl start sshd.service
        CHECK_RESULT $? 0 0 "sctl start sshd.service failed"
        docker exec "${sysmaster_docker_id}" sctl stop sshd.service
        CHECK_RESULT $? 0 0 "sctl stop sshd.service failed"
        docker exec "${sysmaster_docker_id}" sctl restart sshd.service
        CHECK_RESULT $? 0 0 "sctl restart sshd.service failed"
    else
        docker exec -it "${sysmaster_docker_id}" sctl start sshd.service
        CHECK_RESULT $? 0 0 "sctl start sshd.service failed"
        docker exec -it "${sysmaster_docker_id}" sctl stop sshd.service
        CHECK_RESULT $? 0 0 "sctl stop sshd.service failed"
        docker exec -it "${sysmaster_docker_id}" sctl restart sshd.service
        CHECK_RESULT $? 0 0 "sctl restart sshd.service failed"
    fi
    docker stop "${sysmaster_docker_id}"
    CHECK_RESULT $? 0 0 "docker stop failed"
    
    docker rm "${sysmaster_docker_id}"
    CHECK_RESULT $? 0 0 "docker rm failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    docker image rm openeuler-sysmaster:latest openeuler-24.03-lts-sp2:latest
    rm "openEuler-docker.${NODE1_FRAME}.tar"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
