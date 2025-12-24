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
    DNF_INSTALL oedp
    SSH_CMD "dnf install -y python3-libselinux" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    oedp repo update
    oedp init anythingLLM
    ssh-keyscan -H "${NODE2_IPV4}" >> ~/.ssh/known_hosts
    sed -i 's#ansible_host: IP#ansible_host: "${NODE2_IPV4}"#g' ./anythingLLM/config.yaml
    sed -i 's#ansible_password: ''#ansible_password: "${NODE2_PASSWORD}"#g' ./anythingLLM/config.yaml

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p anythingLLM  2>&1 | grep "Execute succeeded: install anythingLLM"
    CHECK_RESULT $? 0 0 "Failed to install anythingLLM"

    oedp run uninstall -p anythingLLM  2>&1 | grep "Execute succeeded: uninstall anythingLLM"
    CHECK_RESULT $? 0 0 "Failed to uninstall anythingLLM"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf anythingLLM
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
