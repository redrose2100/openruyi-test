#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-07-13
#@License       :   Mulan PSL v2
#@Desc          :   KubeEdge Deployment Guide
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ "${NODE1_FRAME}" == "riscv64" ];then
        LOG_WARN "Testing cannot be performed if NODE1_FRAME is riscv64"
        exit 255
    fi
    hostName_bak=$(hostname)
    hostnamectl set-hostname cloud.kubeedge
    echo "${NODE1_IPV4}  cloud.kubeedge" >>/etc/hosts
    DNF_INSTALL "iSulad tar ntp socat conntrack patch"
    wget -O kubeedge-tools.zip https://gitee.com/Poorunga/kubeedge-tools/repository/archive/master.zip
    unzip kubeedge-tools.zip
    P_SSH_CMD --cmd "hostnamectl set-hostname edge.kubeedge" --node 2
    P_SSH_CMD --cmd "dnf install -y iSulad tar ntp patch" --node 2
    P_SSH_CMD --cmd "wget -O kubeedge-tools.zip https://gitee.com/Poorunga/kubeedge-tools/repository/archive/master.zip" --node 2
    P_SSH_CMD --cmd "unzip kubeedge-tools.zip" --node 2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd kubeedge-tools-master || exit
    sed -i "s/ntpdate cn.pool.ntp.org/ntpdate 172.168.131.94/" setup-cloud.sh
    CHECK_RESULT $? 0 0 "Failed to switch the cloud.kubeedge ntp server"
    ./setup-cloud.sh | grep "Done!"
    CHECK_RESULT $? 0 0 "Failed to initialize the cloud.kubeedge environment"
    kubernetes_ver=$(kubeadm config images list | grep "kube-apiserver" | awk -F ":" '{print $NF}')
    for image in $(kubeadm config images list | awk -F "/" '{print $NF}'); do
        isula pull registry.cn-hangzhou.aliyuncs.com/google_containers/"$image"
        isula tag registry.cn-hangzhou.aliyuncs.com/google_containers/"$image" "$(kubeadm config images list | grep "$image")"
        isula rmi registry.cn-hangzhou.aliyuncs.com/google_containers/"$image"
    done
    kubeadm init --apiserver-advertise-address="${NODE1_IPV4}" --kubernetes-version "$kubernetes_ver" --pod-network-cidr=10.244.0.0/16 --upload-certs --cri-socket=/var/run/isulad.sock | grep "initialized successfully"
    CHECK_RESULT $? 0 0 "Failed to initialize your Kubernetes control-plane"
    SLEEP_WAIT 30
    mkdir -p /root/.kube
    cp -i /etc/kubernetes/admin.conf /root/.kube/config
    chown "$(id -u)":"$(id -g)" /root/.kube/config
    export KUBECONFIG=/etc/kubernetes/admin.conf
    ./install-flannel-cloud.sh | grep "condition met"
    CHECK_RESULT $? 0 0 "Failed to install the cloud.kubeedge container network"
    SLEEP_WAIT 15
    kubectl get nodes | grep "Ready"
    CHECK_RESULT $? 0 0 "Failed to deploy the cloud.kubeedge"
    SLEEP_WAIT 10
    running_pods_num=$(kubectl get pods -n kube-system | grep -c "Running")
    test "$running_pods_num" -eq 8
    CHECK_RESULT $? 0 0 "Not all k8s components run successfully"
    kubeedge_ver=$(yum list installed | grep "kubeedge-cloudcore" | awk '{print $2}' | awk -F "-" '{print $1}')
    SLEEP_WAIT 10
    keadm init --advertise-address="${NODE1_IPV4}" --kubeedge-version="$kubeedge_ver" | grep "CloudCore started"
    CHECK_RESULT $? 0 0 "Failed to initialize cluster"
    SLEEP_WAIT 15
    ./patch-cloud.sh
    CHECK_RESULT $? 0 0 "Failed to adjust cloudcore cfg"
    SLEEP_WAIT 5
    systemctl status cloudcore | grep "running"
    CHECK_RESULT $? 0 0 "Failed to deploy cloudcore"
    CLOUD_TOKEN=$(keadm gettoken)
    CHECK_RESULT $? 0 0 "Failed to get the cloud.kubeedge token"

    P_SSH_CMD --cmd "sed -i 's/ntpdate cn.pool.ntp.org/ntpdate 172.168.131.94/' ./kubeedge-tools-master/setup-edge.sh" --node 2
    CHECK_RESULT $? 0 0 "Failed to switch the edge.kubeedge ntp server"
    P_SSH_CMD --cmd "cd kubeedge-tools-master && ./setup-edge.sh | grep 'Done!'" --node 2
    CHECK_RESULT $? 0 0 "Failed to initialize the edge.kubeedge environment"
    SLEEP_WAIT 10
    P_SSH_CMD --cmd "keadm join --cloudcore-ipport=${NODE1_IPV4}:10000 --kubeedge-version=$kubeedge_ver --token=${CLOUD_TOKEN} | grep 'KubeEdge edgecore is running'" --node 2
    CHECK_RESULT $? 0 0 "Failed to manage the edge.kubeedge"
    SLEEP_WAIT 10
    P_SSH_CMD --cmd "cd kubeedge-tools-master && ./patch-edge.sh | grep 'Started edgecore.service'" --node 2
    CHECK_RESULT $? 0 0 "Failed to adjust the edgecore cfg"

    SLEEP_WAIT 5
    ./install-flannel-edge.sh | grep "condition met"
    CHECK_RESULT $? 0 0 "Failed to install the edge.kubeedge container network"
    SLEEP_WAIT 10
    kubectl get nodes | grep "edge.kubeedge"
    CHECK_RESULT $? 0 0 "Failed to deploy the edge.kubeedge"
    kubectl apply -f yamls/nginx-deployment.yaml | grep "deployment.apps/nginx-deployment created"
    CHECK_RESULT $? 0 0 "Failed to create the cloud.kubeedge nginx-deployment"
    SLEEP_WAIT 20
    kubectl get pod -owide | grep "nginx"
    CHECK_RESULT $? 0 0 "Failed to deploy the cloud.kubeedge nginx"
    nginx_ip=$(kubectl get pod -owide | grep nginx | awk '{print $6}')

    P_SSH_CMD --cmd "curl $nginx_ip:80 | grep 'Welcome to nginx!'" --node 2
    CHECK_RESULT $? 0 0 "Failed to access the cloud.kubeedge nginx-service"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ./clean.sh
    keadm reset --force
    kubeadm reset -f
    systemctl disable kubelet
    swapon -a
    rmmod br_netfilter
    setenforce 1
    systemctl start firewalld
    hostnamectl set-hostname "$hostName_bak"
    sed -i '$d' /etc/hosts
    DNF_REMOVE "$@"
    dnf remove -y kubernetes-master kubernetes-kubeadm kubernetes-client kubernetes-kubelet kubeedge-keadm kubeedge-cloudcore
    rm -rf ../kubeedge-tools.zip ../kubeedge-tools-master /root/.kube /etc/sysctl.d/k8s.conf /opt/cni/bin /etc/kubernetes /etc/cni /var/lib/etcd /var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni
    P_SSH_CMD --cmd "cd kubeedge-tools-master && ./clean.sh" --node 2
    P_SSH_CMD --cmd "keadm reset --force" --node 2
    P_SSH_CMD --cmd "hostnamectl set-hostname $hostName_bak" --node 2
    P_SSH_CMD --cmd "dnf remove -y iSulad tar ntp patch kubeedge-keadm kubeedge-edgecore" --node 2
    P_SSH_CMD --cmd "rm -rf kubeedge-tools.zip kubeedge-tools-master" --node 2
    LOG_INFO "End to restore the test environment."
}

main "$@"
