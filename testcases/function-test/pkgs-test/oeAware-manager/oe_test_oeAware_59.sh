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
# shellcheck disable=SC2207,SC2005,SC2046

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" != "aarch64" ]; then
        LOG_INFO "The environment does not support testing"
        exit 255
    fi
    DNF_INSTALL "oeAware-manager docker stress-ng"
    systemctl restart oeaware
    LANG_OLD="${LANG}"
    export LANG=en_US.utf8
    docker_name1="openEuler_test1"
    docker_name2="openEuler_test2"
    version=$(grep PRETTY_NAME /etc/os-release | awk -F '"' '{print $2}' | sed 's/[()]//g;s/ /-/g')
    docker_img="https://dl-cdn.openeuler.openatom.cn/${version}/docker_img/$(uname -i)/openEuler-docker.$(uname -i).tar.xz"
    wget --no-check-certificate "${docker_img}"
    systemctl start docker
    img=$(docker load -i openEuler-docker.$(uname -i).tar.xz | grep "Loaded image")
    img_name=$(echo "${img}" | awk '{print $3}')
    cpus=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
    cpus=$(echo "${cpus}" | bc)
    numa0=$(lscpu | grep -A5 "NUMA node(s)" | grep "NUMA node0" | awk '{print $4}')
    docker run -itd --cpuset-cpus="${numa0}" --cpus=8 --name "${docker_name1}" --privileged -u root "${img_name}" /bin/bash
    docker run -itd --name "${docker_name2}" --privileged -u root "${img_name}" /bin/bash
    docker inspect "${docker_name1}" | grep -i cpu
    docker cp /etc/yum.repos.d/openEuler.repo "${docker_name1}":/etc/yum.repos.d/
    docker exec -d -u root "${docker_name1}" /bin/bash -c "dnf install -y stress-ng;stress-ng --cpu 8"
    SLEEP_WAIT 60
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep host_cpu_usage analysis.log | grep "low for docker coord" && grep docker_cpu_usage analysis.log | grep "high for docker coor"| grep "use docker coordinat" analysis.log
    CHECK_RESULT $? 0 0 "Error: Check suggestion use docker coordinat ion burst failed"
    pkill -9 stress-ng
    SLEEP_WAIT 10
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "use docker coordinat" analysis.log
    CHECK_RESULT $? 1 0 "Error: Check suggestion not use docker coordinat ion burst failed"
    cpus1=$(echo "${cpus}/2" | bc)
    stress-ng --cpu "${cpus1}" &
    docker exec -d -u root "${docker_name1}" /bin/bash -c "stress-ng --cpu 8"
    SLEEP_WAIT 60
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "use docker coordinat" analysis.log
    CHECK_RESULT $? 1 0 "Error: Check suggestion not use docker coordinat ion burst failed"
    pkill -9 stress-ng
    stress-ng --cpu "${cpus1}" &
    SLEEP_WAIT 60
    oeawarectl analysis -t 3 > analysis.log 2>&1
    grep "use docker coordinat" analysis.log
    CHECK_RESULT $? 1 0 "Error: Check suggestion not use docker coordinat ion burst failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pkill -9 stress-ng
    rm -rf analysis.log openEuler-docker.$(uname -i).tar.xz
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    docker rmi $(docker images -q)
    export LANG="${LANG_OLD}"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
