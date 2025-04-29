#!/usr/bin/bash

# Copyright (c) 2023.Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhengyiwen
# @Contact   :   470257028@qq.com
# @Date      :   2023-10-12
# @License   :   Mulan PSL v2
# @Desc      :   isula-build test common
# ############################################
# shellcheck disable=SC2068,SC2034,SC2119,SC1091,SC2154
source ../common/prepare_isulad.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    if yum list | grep -q "docker-runc"; then
        DNF_INSTALL "isula-build docker-runc iSulad wget"
    else
        DNF_INSTALL "isula-build runc iSulad wget"
    fi

    if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "("; then
        os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | tr '()' '- ' | sed s/[[:space:]]//g)
    else
        if grep -i version= /etc/os-release | awk -F '"' '{print$2}' | grep "LTS"; then
            os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}' | awk -F ' ' '{print$1"-"$2}')
        else
            os_version=$(grep -i version= /etc/os-release | awk -F '"' '{print$2}')
        fi
    fi
    wget --no-check-certificate -q -P ../common/ \
        https://repo.openeuler.org/openEuler-"${os_version}"/docker_img/"${NODE1_FRAME}"/openEuler-docker."${NODE1_FRAME}".tar.xz

    systemctl restart isula-build
    isula-build ctr-img load -i ../common/openEuler-docker."${NODE1_FRAME}".tar.xz
    images_name=$(isula-build ctr-img images | grep "docker.io/library/openeuler" | awk '{print$1}')
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    cat > Dockerfile << EOF
FROM "${images_name}":latest
RUN touch build_test
EOF
    isula-build ctr-img build -f Dockerfile -o isulad:openeulerbase:latest .
    CHECK_RESULT $? 0 0 "isula-build build failed"

    con_id=$(isula run -itd openeulerbase:latest bash)
    CHECK_RESULT $? 0 0 "isula run failed"

    isula rm -f "${con_id}"
    isula rmi openeulerbase

    isula-build ctr-img rm openeulerbase "${images_name}"
    CHECK_RESULT $? 0 0 "isula-build rm images failed"
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf Dockerfile
    rm -rf ../common/openEuler-docker."${NODE1_FRAME}".tar.xz
    isula-build ctr-img rm -a
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main $@

