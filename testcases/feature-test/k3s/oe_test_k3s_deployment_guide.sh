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
#@Date          :   2023-07-11
#@License       :   Mulan PSL v2
#@Desc          :   k3s Deployment Guide
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    firewall-cmd --add-port=6443/tcp --zone=public --permanent
    firewall-cmd --add-port=8472/udp --zone=public --permanent
    firewall-cmd --reload
    P_SSH_CMD --cmd "firewall-cmd --add-port=6443/tcp --zone=public --permanent" --node 2
    P_SSH_CMD --cmd "firewall-cmd --add-port=8472/udp --zone=public --permanent" --node 2
    P_SSH_CMD --cmd "firewall-cmd --reload" --node 2
    P_SSH_CMD --cmd "systemctl stop firewalld" --node 2
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL k3s
    hostName_bak=$(hostname)
    hostnamectl set-hostname server
    P_SSH_CMD --cmd "yum install -y k3s" --node 2
    P_SSH_CMD --cmd "hostnamectl set-hostname agent" --node 2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    INSTALL_K3S_SKIP_DOWNLOAD=true k3s-install.sh | grep "Starting k3s"
    CHECK_RESULT $? 0 0 "Failed to start the k3s-server"
    SLEEP_WAIT 30
    kubectl get nodes | grep "Ready"
    CHECK_RESULT $? 0 0 "Failed to deploy the k3s-server"
    server_k3s_token=$(awk -F ":" '{print $NF}' /var/lib/rancher/k3s/server/node-token)
    P_SSH_CMD --cmd "INSTALL_K3S_SKIP_DOWNLOAD=true K3S_URL=https://${NODE1_IPV4}:6443 K3S_TOKEN=$server_k3s_token k3s-install.sh | grep 'Starting k3s-agent'" --node 2
    CHECK_RESULT $? 0 0 "Failed to start the k3s-agent"
    systemctl restart k3s.service
    systemctl status k3s.service | grep "active (running)"
    CHECK_RESULT $? 0 0 "Failed to restart the k3s-server"
    SLEEP_WAIT 30
    kubectl get nodes | grep "agent"
    CHECK_RESULT $? 0 0 "Failed to deploy the k3s-agent"
    kubectl apply -f deployment.yml | grep "deployment.apps/nginx-deployment created"
    CHECK_RESULT $? 0 0 "Failed to create the k3s-server nginx-deployment"
    SLEEP_WAIT 30
    kubectl get pods | grep "Running"
    CHECK_RESULT $? 0 0 "The status of the pods is not running"
    kubectl apply -f service.yml | grep "service/nginx-service created"
    CHECK_RESULT $? 0 0 "Failed to create the k3s-server nginx-service"
    kubectl describe service nginx-service | grep "nginx-service"
    CHECK_RESULT $? 0 0 "The nginx-service information does not exist"
    nginx_ip=$(kubectl describe service nginx-service | grep "Endpoints" | awk -F ":" '{print $2}' | sed "s/[[:space:]]//g")
    P_SSH_CMD --cmd "curl http://$nginx_ip | grep 'Welcome to nginx'" --node 2
    CHECK_RESULT $? 0 0 "Failed to access nginx-service"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    firewall-cmd --remove-port=6443/tcp --zone=public --permanent
    firewall-cmd --remove-port=8472/udp --zone=public --permanent
    firewall-cmd --reload
    P_SSH_CMD --cmd "firewall-cmd --remove-port=6443/tcp --zone=public --permanent" --node 2
    P_SSH_CMD --cmd "firewall-cmd --remove-port=8472/udp --zone=public --permanent" --node 2
    P_SSH_CMD --cmd "firewall-cmd --reload" --node 2
    P_SSH_CMD --cmd "systemctl restart firewalld" --node 2
    hostnamectl set-hostname "$hostName_bak"
    bash -x /usr/local/bin/k3s-uninstall.sh
    P_SSH_CMD --cmd "bash -x /usr/local/bin/k3s-agent-uninstall.sh" --node 2
    LOG_INFO "End to restore the test environment."
}

main "$@"
