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

source "${OET_PATH}/testcases/feature-test/oedp/common.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pre_oedp
    DNF_INSTALL python3-libselinux
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    SLEEP_WAIT 5
    oedp init ragflow
    sed -i 's#ansible_host: NODE_IP#ansible_host: "${NODE1_IPV4}"#g' ./ragflow/config.yaml
    sed -i 's#ansible_port: NODE_PORT#ansible_port: 22#g' ./ragflow/config.yaml
    sed -i 's#ansible_user: NODE_USER#ansible_user: "${NODE1_USER}"#g' ./ragflow/config.yaml
    sed -i 's#ansible_password: NODE_PASSWORD#ansible_password: "${NODE1_PASSWORD}"#g' ./ragflow/config.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p ragflow 2>&1 | grep "Execute succeeded: Install RAGFlow"
    CHECK_RESULT $? 0 0 "Failed to init RAGFlow"

    oedp run uninstall -p ragflow 2>&1 | grep "Execute succeeded: Uninstall RAGFlow"
    CHECK_RESULT $? 0 0 "Failed to uninstall RAGFlow"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ragflow
    post_oedp
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
