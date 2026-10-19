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
# @Desc      :   Multiple deployments of Kubeflow 
# #############################################
# shellcheck disable=SC2016,SC1091
source "./common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "oedp python3-libselinux"
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    LOG_INFO "End to prepare the test environment."
}

function install_kubeflow() {
    build_k8s
    install_helm
    oedp init kubeflow-1.9.1
    sed -i "s|ansible_host: HOST_IP|ansible_host: ${NODE1_IPV4}|g" ./kubeflow-1.9.1/config.yaml
    sed -i "s|ansible_password: \"\"|ansible_password: ${NODE1_PASSWORD}|g" ./kubeflow-1.9.1/config.yaml
    oedp run install -p kubeflow-1.9.1 >install_kubeflow 2>&1
    grep "Execute succeeded: install kubeflow" install_kubeflow
}

function uninstall_kubeflow() {
    oedp run uninstall -p kubeflow-1.9.1 2>&1 | grep "Execute succeeded: uninstall kubeflow"
    uninstall_helm
    uninstall_k8s
    rm -rf kubeflow-1.9.1 install_kubeflow helm-3.9.0 install_helm kubernetes-1.31.1 install_kubernetes
}

function run_test() {
    LOG_INFO "Start run_test"
    
    local total_success=0
    local total_rounds=3
    
    for ((round=1; round<=total_rounds; round++)); do
        LOG_INFO "Starting iteration $round of $total_rounds"
        
	if install_kubeflow; then
            LOG_INFO "Round $round completed successfully"
            ((total_success++))

        else
            LOG_WARN "Round $round had some issues"
        fi

        uninstall_kubeflow

        if [ "$round" -lt "$total_rounds" ]; then
            LOG_INFO "Waiting 5 seconds before next round"
            SLEEP_WAIT 5
        fi

    done
    
    LOG_INFO "Test completion summary: $total_success/$total_rounds rounds successful"
    
    test "$total_success" -eq 3 
    CHECK_RESULT $? 0 0 "Overall test passed with $total_success/$total_rounds successful rounds"
    LOG_INFO "End run_test"
}

function post_test() {
    LOG_INFO "Start post_test"
    
    DNF_REMOVE "$@"

    LOG_INFO "End post_test"
}

main "$@"




