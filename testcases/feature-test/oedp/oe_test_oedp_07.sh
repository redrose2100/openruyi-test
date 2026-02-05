#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Deployment of euler-copilot
# #############################################
# shellcheck disable=SC2016

source "$OET_PATH/libs/locallibs/common_lib.sh"


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oedp python3-libselinux"
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init euler-copilot
    #Embedding模型的API key需要手动修改
    sed -i 's#ansible_host: NODE_IP#ansible_host: "${NODE1_IPV4}"#g' ./euler-copilot/config.yaml
    sed -i 's#ansible_password: ""#ansible_password: "${NODE1_PASSWORD}"#g' ./euler-copilot/config.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p euler-copilot 2>&1 | grep "Execute succeeded: install EulerCopilot"
    CHECK_RESULT $? 0 0 "Failed to init RAGFlow"

    oedp run uninstall -p euler-copilot 2>&1 | grep "Execute succeeded: uninstall EulerCopilot"
    CHECK_RESULT $? 0 0 "Failed to uninstall RAGFlow"


    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf euler-copilot
    DNF_remove "$@"

    LOG_INFO "End to restore the test environment."
}


main "$@"
