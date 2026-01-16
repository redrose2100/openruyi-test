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
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Deployment of AnythingLLM 
# #############################################
# shellcheck disable=SC2016

source "$OET_PATH/libs/locallibs/common_lib.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oedp python3-libselinux"
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    ln -s /usr/bin/containerd-shim-runc-v2 /usr/local/bin/containerd-shim-runc-v2
    min_mem_gb=$(free -m | awk '/^Mem:/ {print int($7/1024)}')
    disk_gb=$(df -BG / | tail -1 | awk '{print $4}' | sed 's/G//')
    cpu_num=$(nproc)
    oedp repo update
    SLEEP_WAIT 5
    oedp init ragflow
    sed -i "s#ansible_host: NODE_IP#ansible_host: "${NODE1_IPV4}"#g" ./ragflow/config.yaml
    sed -i 's#ansible_port: NODE_PORT#ansible_port: 22#g' ./ragflow/config.yaml
    sed -i "s#ansible_user: NODE_USER#ansible_user: "${NODE1_USER}"#g" ./ragflow/config.yaml
    sed -i "s|ansible_password: NODE_PASSWORD|ansible_password: "${NODE1_PASSWORD}"|g" ./ragflow/config.yaml
    sed -i "s|MIN_CPU: .*$|MIN_CPU: "${cpu_num}"|g" ./ragflow/config.yaml
    sed -i "s|MIN_MEM_GB: .*$|MIN_MEM_GB: "${min_mem_gb}"|g" ./ragflow/config.yaml
    sed -i "s|MIN_DISK_GB: .*$|MIN_DISK_GB: "${disk_gb}"|g" ./ragflow/config.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p ragflow >install_ragflow 2>&1
    CHECK_RESULT $? 0 0 "Failed to install RAGFlow"

    grep "Execute succeeded: Install RAGFlow" install_ragflow 
    CHECK_RESULT $? 0 0 "Failed to check log of RAGFlow"

    oedp run uninstall -p ragflow 2>&1 | grep "Execute succeeded: Uninstall RAGFlow"
    CHECK_RESULT $? 0 0 "Failed to uninstall RAGFlow"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ragflow install_ragflow
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
