#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2025-07-22
#@License       :   Mulan PSL v2
#@Desc          :   oeAware test
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager docker"
    systemctl restart oeaware
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    docker_name1="openEuler_test1"
    docker_name2="openEuler_test2"
    version=$(grep PRETTY_NAME /etc/os-release | awk -F '"' '{print $2}' | sed 's/[()]//g;s/ /-/g')
    docker_img="https://dl-cdn.openeuler.openatom.cn/${version}/docker_img/$(uname -i)/openEuler-docker.$(uname -i).tar.xz"
    wget --no-check-certificate "${docker_img}"
    systemctl start docker
    img=$(docker load -i openEuler-docker."$(uname -i)".tar.xz | grep "Loaded image")
    img_name=$(echo "${img}" | awk '{print $3}')
    numa0=$(lscpu | grep -A5 "NUMA node(s)" | grep "NUMA node0" | awk '{print $4}')
    docker run -itd --cpuset-cpus="${numa0}" --cpus=8 --name "${docker_name1}" --privileged -u root "${img_name}" /bin/bash
    docker run -itd --cpuset-cpus="${numa0}" --cpus=8 --name "${docker_name2}" --privileged -u root "${img_name}" /bin/bash
    cp /etc/oeAware/plugin/docker_burst.yaml /etc/oeAware/plugin/docker_burst.yaml_bak
    sed -i 's/ratio:.*/ratio: 3.1615/' /etc/oeAware/plugin/docker_burst.yaml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl -e docker_burst | grep "Instance enabled failed, because CoordinationBurstAdapt Param ratio should be integer"
    CHECK_RESULT $? 0 0 "Error: Check enable docker_burst failed"
    sed -i 's/ratio:.*/ratio: 3a/' /etc/oeAware/plugin/docker_burst.yaml
    oeawarectl -e docker_burst | grep "Instance enabled failed, because CoordinationBurstAdapt Param ratio should be integer"
    CHECK_RESULT $? 0 0 "Error: Check enable docker_burst failed"
    sed -i 's/ratio:.*/ratio: abc/' /etc/oeAware/plugin/docker_burst.yaml
    oeawarectl -e docker_burst | grep "Instance enabled failed, because CoordinationBurstAdapt Param ratio should be integer"
    CHECK_RESULT $? 0 0 "Error: Check enable docker_burst failed"
    sed -i 's/ratio:.*/ratio: #$%()/' /etc/oeAware/plugin/docker_burst.yaml
    oeawarectl -e docker_burst | grep "Instance enabled failed, because CoordinationBurstAdapt Param ratio should be integer"
    CHECK_RESULT $? 0 0 "Error: Check enable docker_burst failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf openEuler-docker."$(uname -i)".tar.xz
    mv -f /etc/oeAware/plugin/docker_burst.yaml_bak /etc/oeAware/plugin/docker_burst.yaml
    docker stop "$(docker ps -aq)"
    docker rm "$(docker ps -aq)"
    docker rmi "$(docker images -q)"
    export LANG="${LANG_OLD}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
