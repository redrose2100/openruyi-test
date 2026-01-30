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
# @Desc      :   Prepare the test environment
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function build_k8s() {
    LOG_INFO "Start to install kubernetes"
    DNF_INSTALL "oedp python3-libselinux"
    oedp repo update
    CHECK_RESULT $? 0 0 "Failed to update repo!"

    oedp init kubernetes-1.31.1
    CHECK_RESULT $? 0 0 "Failed to init kubernetes!"

    oedp info -p kubernetes-1.31.1 2>&1 | grep "name: kubernetes"
    CHECK_RESULT $? 0 0 "Failed to view info of kubernetes!"
    
    sed -i "s/HOST_IP1/${NODE1_IPV4}/g" ./kubernetes-1.31.1/config.yaml
    sed -i "s/HOST_IP4/${NODE2_IPV4}/g" ./kubernetes-1.31.1/config.yaml
    sed -i "s/HOST_IP5/${NODE3_IPV4}/g" ./kubernetes-1.31.1/config.yaml
    sed -i '/'"${NODE1_IPV4}"':/,/runtime:/ s|ansible_password: ""|ansible_password: "'"${NODE1_PASSWORD}"'"|' ./kubernetes-1.31.1/config.yaml
    sed -i '/'"${NODE2_IPV4}"':/,/runtime:/ s|ansible_password: ""|ansible_password: "'"${NODE2_PASSWORD}"'"|' ./kubernetes-1.31.1/config.yaml
    sed -i '/'"${NODE3_IPV4}"':/,/runtime:/ s|ansible_password: ""|ansible_password: "'"${NODE3_PASSWORD}"'"|' ./kubernetes-1.31.1/config.yaml
    for i in 1 2 3; do
    frame_var="NODE${i}_FRAME"
    ip_var="NODE${i}_IPV4"
    [ "${!frame_var}" = "aarch64" ] && \
    sed -i "/${!ip_var}:/,/architecture:/{s#architecture: amd64#architecture: arm64#}" ./kubernetes-1.31.1/config.yaml
  done

    oedp run install -p kubernetes-1.31.1 > install_kubernetes 2>&1
    grep "Execute succeeded: install kubernetes" install_kubernetes
    CHECK_RESULT $? 0 0 "Failed to deployment kubernetes"

    kubectl get pod -n kubeflow --no-headers | grep -v "Running"
    LOG_INFO "End to install kubernetes."
}

function uninstall_k8s() {
    LOG_INFO "Start uninstall k8s"
    oedp run uninstall -p kubernetes-1.31.1 2>&1 | grep "Execute succeeded: delete kubernetes"
    CHECK_RESULT $? 0 0 "Failed to uninstall kubernetes"
    rm -rf install_kubernetes
    DNF_REMOVE "$@"
    LOG_INFO "End to uninstall k8s"
}

function install_helm() {
    LOG_INFO "Start to install helm"
    DNF_INSTALL "oedp python3-libselinux"
    oedp repo update
    CHECK_RESULT $? 0 0 "Failed to update repo!"

    oedp init helm-3.9.0
    CHECK_RESULT $? 0 0 "Failed to init helm-3.9.0!"


    sed -i "s/HOST1_IP/${NODE1_IPV4}/g" ./helm-3.9.0/config.yaml
    sed -i "s/PASSWORD/${NODE1_PASSWORD}/g" ./helm-3.9.0/config.yaml
    frame_var="NODE${i}_FRAME"
    [ "${!frame_var}" = "aarch64" ] && \
    sed -i "s/amd64/arm64/g" ./helm-3.9.0/config.yaml
    oedp run install -p  helm-3.9.0 >install_helm 2>&1
    grep "Execute succeeded: install helm" install_helm
    CHECK_RESULT $? 0 0 "Failed to deployment helm"
}

function uninstall_helm() {
    LOG_INFO "Start uninstall helm"
    oedp run uninstall -p helm-3.9.0 2>&1 | grep "Execute succeeded: delete helm"
    CHECK_RESULT $? 0 0 "Failed to uninstall helm-3.9.0"
    rm -rf install_helm helm-3.9.0
    DNF_REMOVE "$@"
    LOG_INFO "End to uninstall helm"
}
main "$@"




