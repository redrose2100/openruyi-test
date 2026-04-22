#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sjxjx
# @Contact   :   3541335833@qq.com
# @Date      :   2026-04-22
# @License   :   Mulan PSL v2
# @Desc      :   Test kubectl command and kubernetes cluster basic functionality
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    swapoff -a
    kube_version=$(dnf info kubernetes 2>/dev/null | grep -wi version | awk '{print $NF}')
    if [ -z "$kube_version" ]; then
        LOG_INFO "Kubernetes not installed, installing now..."
        DNF_INSTALL "kubernetes-client"
    else
        if [[ "$(printf '%s\n' "$kube_version" "1.21" | sort -V | head -n1)" == "1.21" ]]; then
            DNF_INSTALL "containerd kubernetes-kubelet conntrack-tools cri-tools iptables kubernetes-client"
            systemctl start containerd 2>/dev/null || true
        else
            DNF_INSTALL "docker-engine kubernetes-kubelet conntrack-tools iptables kubernetes-client"
            systemctl start docker 2>/dev/null || true
        fi
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing kubectl basic functionality."

    # Test 1: Check kubectl version
    LOG_INFO "Test 1: Check kubectl version"
    kubectl version --client 2>/dev/null
    CHECK_RESULT $? 0 0 "kubectl version check failed"

    # Test 2: Check kubectl help
    LOG_INFO "Test 2: Check kubectl help"
    kubectl --help 2>/dev/null | grep -i "kubectl"
    CHECK_RESULT $? 0 0 "kubectl help check failed"

    # Test 3: Check kubectl config view
    LOG_INFO "Test 3: Check kubectl config view"
    kubectl config view 2>/dev/null
    CHECK_RESULT $? 0 0 "kubectl config view failed"

    # Test 4: Check kubectl cluster-info
    LOG_INFO "Test 4: Check kubectl cluster-info"
    kubectl cluster-info 2>&1 | head -n 5
    CHECK_RESULT $? 0 0 "kubectl cluster-info failed"

    # Test 5: Check kubectl get nodes
    LOG_INFO "Test 5: Check kubectl get nodes"
    kubectl get nodes 2>&1 | head -n 5
    CHECK_RESULT $? 0 0 "kubectl get nodes failed"

    # Test 6: Check kubectl get pods
    LOG_INFO "Test 6: Check kubectl get pods"
    kubectl get pods --all-namespaces 2>&1 | head -n 5
    CHECK_RESULT $? 0 0 "kubectl get pods failed"

    # Test 7: Check kubectl get services
    LOG_INFO "Test 7: Check kubectl get services"
    kubectl get services --all-namespaces 2>&1 | head -n 5
    CHECK_RESULT $? 0 0 "kubectl get services failed"

    # Test 8: Check kubectl get namespaces
    LOG_INFO "Test 8: Check kubectl get namespaces"
    kubectl get namespaces 2>&1 | head -n 10
    CHECK_RESULT $? 0 0 "kubectl get namespaces failed"

    # Test 9: Check kubectl api-resources
    LOG_INFO "Test 9: Check kubectl api-resources"
    kubectl api-resources 2>&1 | head -n 10
    CHECK_RESULT $? 0 0 "kubectl api-resources failed"

    # Test 10: Check kubectl explain
    LOG_INFO "Test 10: Check kubectl explain"
    kubectl explain pod 2>&1 | head -n 10
    CHECK_RESULT $? 0 0 "kubectl explain failed"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    swapon -a
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
