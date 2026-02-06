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
# @Desc      :   Deployment of kubeflow-1.9.1
# #############################################
# shellcheck disable=SC2016,SC1091
source "./common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    build_k8s
    install_helm
    DNF_INSTALL "oedp python3-libselinux"
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init kubeflow-1.9.1
    sed -i "s#ansible_host: HOST_IP#ansible_host: ${NODE1_IPV4}#g" ./kubeflow-1.9.1/config.yaml
    sed -i "s#ansible_password: \"\"#ansible_password: ${NODE1_PASSWORD}#g" ./kubeflow-1.9.1/config.yaml
    cp kubeflow-1.9.1/workspace/roles/install/tasks/main.yml kubeflow-1.9.1/workspace/roles/install/tasks/main.yml.bak
    sed -i '/^while ! kubectl get ns kubeflow-user-example-com/,/^done$/ s/^/#/' kubeflow-1.9.1/workspace/roles/install/tasks/main.yml
    sed -i '/^kubectl label namespace kubeflow-user-example-com istio-injection--/ s/^/#/' kubeflow-1.9.1/workspace/roles/install/tasks/main.yml
    sleep 30
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    oedp run install -p kubeflow-1.9.1 > install_kubeflow_log 2>&1
    if grep -q "certificate signed by unknown authority" install_kubeflow_log; then
        LOG_INFO "Detected cert-manager certificate issue, waiting and retrying..."

        # 等待 cert-manager 就绪
        kubectl wait --for=condition=ready pod --all -n cert-manager --timeout=180s
        sleep 30

        # 手动完成 PVC Viewer 安装
        kustomize build /tmp/kubeflow-install/manifests-1.9.1/apps/pvcviewer-controller/upstream/default | kubectl apply -f -

        # 重新运行 oedp 安装（会继续剩余任务）
        oedp run install -p kubeflow-1.9.1 >> install_kubeflow_log 2>&1 || true
    fi
    grep "Execute succeeded: install kubeflow" install_kubeflow_log
    CHECK_RESULT $? 0 0 "Failed to install kubeflow"

    elapsed_time=$(grep "Elapsed time:" install_kubeflow_log | awk -F': ' '{print $2}' | awk '{print $1}')
    total_seconds=$(echo "$elapsed_time" | awk -F: '{print ($1*3600) + ($2*60) + $3}')
    test "$(echo "$total_seconds < 600" | bc)" -eq 1
    CHECK_RESULT $? 0 0 "Failed to verify that the average deployment time of kubeflow is less than 10 minutes"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    
    uninstall_helm
    uninstall_k8s
    rm -rf kubeflow-1.9.1 install_kubeflow_log helm-3.9.0 install_helm kubernetes-1.31.1 install_kubernetes
    DNF_remove "$@" 

    LOG_INFO "End to restore the test environment."
}

main "$@"
